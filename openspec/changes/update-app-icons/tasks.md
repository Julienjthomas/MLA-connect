## 1. Pre-flight checks

- [ ] 1.1 Confirm source folder `/Users/julien/Downloads/AppIcons` still present and intact
- [ ] 1.2 Check `android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml` — if exists, decide whether to remove (adaptive icon would override PNG) or keep and update foreground/background
- [ ] 1.3 Note any `ic_launcher_round.png` in repo mipmaps (round icon variant)

## 2. Android icon swap

- [ ] 2.1 Copy `AppIcons/android/mipmap-mdpi/ic_launcher.png` → `android/app/src/main/res/mipmap-mdpi/ic_launcher.png`
- [ ] 2.2 Copy `AppIcons/android/mipmap-hdpi/ic_launcher.png` → `android/app/src/main/res/mipmap-hdpi/ic_launcher.png`
- [ ] 2.3 Copy `AppIcons/android/mipmap-xhdpi/ic_launcher.png` → `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png`
- [ ] 2.4 Copy `AppIcons/android/mipmap-xxhdpi/ic_launcher.png` → `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png`
- [ ] 2.5 Copy `AppIcons/android/mipmap-xxxhdpi/ic_launcher.png` → `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png`
- [ ] 2.6 If `ic_launcher_round.png` existed in any mipmap dir, overwrite with the same new `ic_launcher.png` per density (or remove + drop reference in `AndroidManifest.xml`)

## 3. iOS icon swap

- [ ] 3.1 Copy `AppIcons/Assets.xcassets/AppIcon.appiconset/40.png`   → `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png`
- [ ] 3.2 Copy `AppIcons/.../40.png`   → `.../Icon-App-40x40@1x.png`
- [ ] 3.3 Copy `AppIcons/.../60.png`   → `.../Icon-App-20x20@3x.png`
- [ ] 3.4 Copy `AppIcons/.../29.png`   → `.../Icon-App-29x29@1x.png`
- [ ] 3.5 Copy `AppIcons/.../58.png`   → `.../Icon-App-29x29@2x.png`
- [ ] 3.6 Copy `AppIcons/.../87.png`   → `.../Icon-App-29x29@3x.png`
- [ ] 3.7 Copy `AppIcons/.../80.png`   → `.../Icon-App-40x40@2x.png`
- [ ] 3.8 Copy `AppIcons/.../120.png`  → `.../Icon-App-40x40@3x.png`
- [ ] 3.9 Copy `AppIcons/.../120.png`  → `.../Icon-App-60x60@2x.png`
- [ ] 3.10 Copy `AppIcons/.../180.png` → `.../Icon-App-60x60@3x.png`
- [ ] 3.11 Copy `AppIcons/.../20.png`  → `.../Icon-App-20x20@1x.png`
- [ ] 3.12 Copy `AppIcons/.../76.png`  → `.../Icon-App-76x76@1x.png`
- [ ] 3.13 Copy `AppIcons/.../152.png` → `.../Icon-App-76x76@2x.png`
- [ ] 3.14 Copy `AppIcons/.../167.png` → `.../Icon-App-83.5x83.5@2x.png`
- [ ] 3.15 Copy `AppIcons/.../1024.png` → `.../Icon-App-1024x1024@1x.png`
- [ ] 3.16 Confirm `Contents.json` was not modified

## 4. Verify & build

- [ ] 4.1 `flutter clean`
- [ ] 4.2 `flutter pub get`
- [ ] 4.3 `flutter build apk --debug` — confirm Android build succeeds
- [ ] 4.4 `flutter build ios --debug --no-codesign` — confirm iOS build succeeds
- [ ] 4.5 Install on Android device/emulator, uninstall first to bust icon cache, verify new launcher icon
- [ ] 4.6 Install on iOS simulator/device, verify home-screen, Settings, and Spotlight icons
- [ ] 4.7 Commit assets — single commit, scoped message `chore(branding): update app launcher icons`

## 5. Store-listing icons (manual, out of repo)

- [ ] 5.1 Note: upload `AppIcons/playstore.png` (512×512) to Play Console listing
- [ ] 5.2 Note: upload `AppIcons/appstore.png` (1024×1024) to App Store Connect listing
