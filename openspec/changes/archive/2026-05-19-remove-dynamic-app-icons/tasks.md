## 1. Flutter: Remove Service and Call-sites

- [ ] 1.1 Delete `lib/core/services/app_icon_service.dart`
- [ ] 1.2 Remove `AppIconService` import and `applyPendingAndroid` call from `lib/main.dart` (`AppLifecycleListener.onPause` hook)
- [ ] 1.3 Remove `AppIconService` import and `setForConstituency` call from `lib/features/auth/controllers/auth_controller.dart` (login flow)
- [ ] 1.4 Remove `AppIconService` import and `clearToDefault` call from `lib/features/auth/controllers/auth_controller.dart` (logout flow)
- [ ] 1.5 Remove `AppIconService` import and `setForConstituency` call from `lib/features/onboarding/views/constituency_view.dart`

## 2. Android: Remove Aliases and Restore Launcher

- [ ] 2.1 Add `LAUNCHER` intent-filter directly to `<activity android:name=".MainActivity">` in `android/app/src/main/AndroidManifest.xml`
- [ ] 2.2 Remove all four `<activity-alias>` blocks (`DefaultAlias`, `BalusseryAlias`, `KoduvalliAlias`, `PerambraAlias`) from `android/app/src/main/AndroidManifest.xml`
- [ ] 2.3 Remove MethodChannel registration and `setIcon` handler from `android/app/src/main/kotlin/systems/keyvalue/super_balussery/MainActivity.kt`
- [ ] 2.4 Remove unused imports (`ComponentName`, `ApplicationInfo`, `PackageManager`, `NameNotFoundException`, `FlutterEngine`, `MethodChannel`) from `MainActivity.kt`
- [ ] 2.5 Delete alternate icon mipmap directories: `android/app/src/main/res/mipmap-*/ic_launcher_balussery`, `ic_launcher_koduvalli`, `ic_launcher_perambra`

## 3. iOS: Remove Alternate Icons

- [ ] 3.1 Remove `CFBundleAlternateIcons` dictionary from `ios/Runner/Info.plist`
- [ ] 3.2 Remove MethodChannel handler (`setIcon` block) from `ios/Runner/AppDelegate.swift`
- [ ] 3.3 Delete `ios/Runner/Assets.xcassets/AlternateIcons/` directory (or equivalent alternate icon image folder)

## 4. Verify

- [ ] 4.1 Run `flutter analyze` — no errors
- [ ] 4.2 Build Android debug: `flutter build apk --debug` — app launches from home screen
- [ ] 4.3 Build iOS simulator: `flutter build ios --simulator` — app launches with default icon
