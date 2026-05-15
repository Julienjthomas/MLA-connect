## Why

App currently displays "Ente MLA" as its name across all surfaces (launcher, title bar, l10n strings). The product name has been updated to "MLA Connect" and needs to be reflected consistently everywhere.

## What Changes

- Update English l10n `appName` from `"Ente MLA"` to `"MLA Connect"`
- Update `GetMaterialApp` `title` in `main.dart` from `'Ente MLA'` to `'MLA Connect'`
- Update iOS `CFBundleDisplayName` and `CFBundleName` in `Info.plist`
- Update Android `app_name` string in `strings.xml`
- English localization is the default/fallback; Malayalam (`app_ml.arb`) keeps its localized name `"സൂപ്പർ ബാലുശ്ശേരി"` unchanged

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `multi-constituency-branding`: Default app name displayed to users changes from "Ente MLA" to "MLA Connect" across all platform surfaces.

## Impact

- `lib/main.dart` — `title` prop
- `lib/l10n/app_en.arb` — `appName` key
- `lib/l10n/app_localizations_en.dart` — generated, may need manual sync
- `ios/Runner/Info.plist` — `CFBundleDisplayName`, `CFBundleName`
- `android/app/src/main/res/values/strings.xml` — `app_name`
