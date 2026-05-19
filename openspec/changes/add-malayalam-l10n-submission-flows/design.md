## Context

The app uses Flutter's `gen-l10n` system (`app_en.arb` / `app_ml.arb` → generated `AppLocalizations`). All localized strings flow through `AppStrings`, a static façade that reads the current locale via `AppLocale.current`. Enum labels (e.g. `SubmissionVisibility.label`) already use `AppStrings`; `ReportCategory.label` does not. The four submission flow step widgets contain hardcoded English string literals, bypassing the pipeline entirely.

## Goals / Non-Goals

**Goals:**
- Every visible string in the Report, Idea, Appreciate, and Suggest-Improvement flows resolves through `AppStrings` / ARB
- Perfect, natural Malayalam for all new keys in `app_ml.arb`
- `ReportCategory.label` localized through `AppStrings`
- No English fallbacks visible to a Malayalam user during normal flow

**Non-Goals:**
- Adding a third language (e.g. Hindi) — only `ml` is in scope
- Changing UI layout or UX beyond string substitution
- Localizing strings in flows not listed (onboarding, profile, updates, chat)
- Runtime locale-switching within the flow (already handled by the existing locale system)

## Decisions

### D1: Add keys to ARB, not inline in Dart
All new strings are added as ARB keys rather than inline translated constants in Dart. Keeps all translations in one place, stays consistent with existing pattern, and is required for `flutter gen-l10n` to regenerate typed accessors.

*Alternative considered*: Dart-side extension methods on locale — rejected because it splits the translation source of truth.

### D2: Key naming convention — `<flow><Step><Concept>`
Pattern: `report` / `idea` / `appreciat` / `improve` prefix + step suffix when the string is step-specific; shared concepts (e.g. "Next: Review →") get a shared key like `nextReview`, `nextVisibility`. Avoids per-flow duplication where the string is identical across flows.

*Shared button strings already in ARB* (`next`, `submit`, `back`) will be reused where the text matches exactly. New compound strings (e.g. "Next: Review →") get dedicated keys because phrasing may diverge across flows.

### D3: ReportCategory labels via AppStrings
Add one `AppStrings` getter per category (e.g. `AppStrings.categoryRoad`). Several category keys already exist in the ARB (`categoryRoad`, `categoryWater`, etc.); verify coverage and add any missing ones. Update `ReportCategoryX.label` to reference `AppStrings.*` instead of hardcoded strings.

*Alternative*: Pass `BuildContext` into `.label` — rejected because it would require threading context through every call site; AppStrings already solves this correctly.

### D4: Regenerate `app_localizations_ml.dart` via `flutter gen-l10n`
The generated file must be regenerated after every ARB edit. Do not hand-edit the generated file. The task list will include this as an explicit step.

## Risks / Trade-offs

- **Missing key at runtime** → `flutter gen-l10n` will fail at build time if a key exists in `app_en.arb` but not `app_ml.arb`, catching omissions before shipping.
- **ARB key collisions with future work** → Naming convention in D2 is scoped to flow + concept; low collision risk.
- **Malayalam translation quality** → Strings are authored by the implementer; a native speaker review pass is recommended before release. The spec for each flow includes the intended Malayalam text for verification.
