## 1. L10n Strings

- [x] 1.1 Update `lib/l10n/app_en.arb`: change `"appName"` value from `"Ente MLA"` to `"MLA Connect"`
- [x] 1.2 Update `lib/l10n/app_localizations_en.dart`: change `appName` getter return value from `'Ente MLA'` to `'MLA Connect'`

## 2. Flutter App Title

- [x] 2.1 Update `lib/main.dart`: change `GetMaterialApp` `title` prop from `'Ente MLA'` to `'MLA Connect'`

## 3. Platform Configs

- [x] 3.1 Update `android/app/src/main/res/values/strings.xml`: change `app_name` string from `Ente MLA` to `MLA Connect`
- [x] 3.2 Update `ios/Runner/Info.plist`: change `CFBundleDisplayName` value from `Ente MLA` to `MLA Connect`
- [x] 3.3 Update `ios/Runner/Info.plist`: change `CFBundleName` value from `Ente MLA` to `MLA Connect`

## 4. Verification

- [x] 4.1 Run `flutter analyze` — no errors
- [ ] 4.2 Hot restart on Android emulator — launcher label shows "MLA Connect"
- [ ] 4.3 Hot restart on iOS simulator — home screen label shows "MLA Connect"
- [ ] 4.4 Confirm splash screen and app bar display "MLA Connect"
