## Context

Localization lives in two ARB files: `lib/l10n/app_en.arb` (English) and `lib/l10n/app_ml.arb` (Malayalam). Flutter's `gen-l10n` generates `app_localizations_en.dart` and `app_localizations_ml.dart` from these. `AppStrings` in `lib/core/constants/app_strings.dart` exposes typed accessors to the rest of the app.

Two distinct problems need fixing in one pass:
1. **Wrong/missing Malayalam translations** — many keys in `app_ml.arb` have incorrect or placeholder text; several keys present in the English ARB are missing from the Malayalam ARB entirely.
2. **"Report" → "Issue" rename** — user-facing English string _values_ (not key names) in activity tabs, empty states, and community impact stats still say "report(s)" where the app's design language uses "issue(s)". The same rename applies to the equivalent Malayalam strings.

## Goals / Non-Goals

**Goals**
- Correct Malayalam string values to match the translations supplied by the user.
- Add Malayalam values for keys that are missing from `app_ml.arb`.
- Update English string _values_ (not ARB key identifiers) for the report→issue rename in user-facing labels.
- Keep ARB key names unchanged to avoid Dart code churn.

**Non-Goals**
- Renaming ARB keys or `AppStrings` accessors (would require touching every call-site).
- Translating strings that were not provided by the user.
- Changes to any Dart source files other than the generated localizations.

## Decisions

### Decision 1: Edit ARB values only, not key names
Renaming keys (`activityTabReports` → `activityTabIssues`) would require updating `AppStrings` and every widget that calls those getters. Changing only the string _values_ achieves the user-facing rename with zero Dart changes.

**Alternative considered**: Rename keys for semantic accuracy. Rejected — disproportionate churn for a display-string fix.

### Decision 2: Single-pass edit of both ARB files
Both files will be edited in one task. `flutter gen-l10n` is run once at the end to regenerate the Dart bindings.

### Decision 3: Provided translations are authoritative
The translations supplied in the change request are accepted as-is. No back-translation check is performed.

## Risks / Trade-offs

- [Risk] A key present in `app_en.arb` but absent from `app_ml.arb` causes `gen-l10n` to fall back to English silently → Mitigation: adding all missing keys in this change eliminates the gap.
- [Risk] `flutter gen-l10n` fails if ARB JSON is malformed → Mitigation: validate JSON syntax before committing (run `python3 -m json.tool` on both files).

## Migration Plan

1. Edit `lib/l10n/app_ml.arb` — correct existing values and add missing keys.
2. Edit `lib/l10n/app_en.arb` — update report→issue string values.
3. Run `flutter gen-l10n` (or `flutter pub run intl_utils:generate`) to regenerate Dart bindings.
4. Run `flutter analyze` to confirm no compilation errors.
5. No rollback complexity — ARB edits are fully reversible via git.

## Open Questions

None. All translations have been provided.
