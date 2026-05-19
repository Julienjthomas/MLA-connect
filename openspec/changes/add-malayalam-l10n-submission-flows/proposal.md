## Why

All four citizen submission flows — Report a Problem, Share Idea, Appreciate, and Suggest Improvement — contain dozens of hardcoded English strings (step headings, field labels, hints, button text, success messages, category names) that never reach the ARB pipeline and therefore display in English even when the user has selected Malayalam. This blocks the app from being genuinely usable for Malayalam-speaking constituents.

## What Changes

- Add ~60 new ARB keys covering every hardcoded string across the four submission flow step widgets (details step, location step, visibility step, review step, success step for each flow)
- Add perfect Malayalam translations for all new keys in `app_ml.arb`
- Localize `ReportCategory.label` values, which are currently hardcoded English in `app_enums.dart`
- Add corresponding `AppStrings` getters for all new keys
- Replace every hardcoded string literal in the eight affected step widgets and flow views with `AppStrings.*` references

## Capabilities

### New Capabilities
- `report-problem-l10n`: Full Malayalam localization of the Report a Problem flow (details, location, visibility, review, success steps)
- `share-idea-l10n`: Full Malayalam localization of the Share Idea flow (details, impact, visibility, review, success steps)
- `appreciate-l10n`: Full Malayalam localization of the Appreciate flow (recipient, message, visibility, review, success steps)
- `suggest-improvement-l10n`: Full Malayalam localization of the Suggest Improvement flow (suggestion, location, review, success steps)

### Modified Capabilities
- `report-problem`: `ReportCategory` enum labels must now be localized through AppStrings rather than hardcoded English strings

## Impact

- `lib/l10n/app_en.arb` — ~60 new keys added
- `lib/l10n/app_ml.arb` — ~60 Malayalam translations added
- `lib/core/constants/app_strings.dart` — ~60 new static getters
- `lib/core/constants/app_enums.dart` — `ReportCategory.label` switch uses `AppStrings.*`
- `lib/features/report/views/steps/` — all 4 step files updated
- `lib/features/appreciation/views/steps/` — all 4 step files + flow view updated
- `lib/features/ideas/views/steps/` — all 5 step files + flow view updated
- `lib/features/improvements/views/steps/` — all 4 step files + flow view updated
- Generated: `lib/l10n/app_localizations_ml.dart` (regenerated via `flutter gen-l10n`)
