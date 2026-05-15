## Context

App name "Ente MLA" is hardcoded in five places: `main.dart` title, English ARB file, generated English l10n class, iOS `Info.plist`, and Android `strings.xml`. The Malayalam ARB already uses a localized name (`"സൂപ്പർ ബാലുശ്ശേരി"`) which is correct and untouched.

The `app_localizations_en.dart` file is code-generated from `app_en.arb`. Flutter's `flutter gen-l10n` regenerates it, so updating the ARB source is the canonical change; the generated file must be updated manually if regeneration isn't run.

## Goals / Non-Goals

**Goals:**
- All English-language surfaces show "MLA Connect" as the app name
- Change is consistent across launcher icon label (Android/iOS), in-app title bar, and l10n string

**Non-Goals:**
- Changing the Malayalam localized app name
- Changing the Flutter package name (`super_balussery`) or bundle ID
- Updating any app store metadata or icons

## Decisions

**Update source ARB, generated file, and platform configs directly** — rather than running `flutter gen-l10n` as part of this change, update the generated `app_localizations_en.dart` manually alongside the ARB. This avoids a build-tool dependency in the task and keeps the change atomic.

**Leave `app_ml.arb` unchanged** — the Malayalam name is a deliberate localization, not a bug. Only the English default changes.

## Risks / Trade-offs

- `app_localizations_en.dart` is generated — if `flutter gen-l10n` is run later and the ARB is updated correctly, the generated file will stay correct. Low risk.
- iOS `CFBundleDisplayName` vs `CFBundleName`: both should match. If only one is updated, behavior varies by context (home screen vs Settings). Update both.

## Migration Plan

1. Update `app_en.arb`
2. Update `app_localizations_en.dart` (generated) to match
3. Update `main.dart` `title` prop
4. Update `ios/Runner/Info.plist` both keys
5. Update `android/app/src/main/res/values/strings.xml`
6. Hot restart and verify on both platforms

Rollback: revert any of the above files — no DB or API changes involved.
