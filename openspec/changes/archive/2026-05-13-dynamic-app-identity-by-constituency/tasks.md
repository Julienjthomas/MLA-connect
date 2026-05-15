## 1. Dependencies & Package Setup

- [x] 1.1 Add `flutter_dynamic_icon: ^2.0.0` to `pubspec.yaml` dependencies
- [x] 1.2 Run `flutter pub get` and verify no conflicts
- [x] 1.3 Verify `flutter_dynamic_icon` Android and iOS setup requirements (README)

## 2. Icon Assets — iOS

- [x] 2.1 Create placeholder icon PNGs for each variant: `balussery`, `koduvalli`, `perambra` (tinted @2x/@3x copies in `ios/Runner/AlternateIcons/`)
- [x] 2.2 Icons placed outside `Assets.xcassets` per plugin requirement (in `ios/Runner/AlternateIcons/`)
- [x] 2.3 Update `ios/Runner/Info.plist` — add `CFBundleIcons` → `CFBundleAlternateIcons` with entries for `balussery`, `koduvalli`, `perambra`

## 3. Icon Assets — Android

- [x] 3.1 Add constituency icon drawables to `android/app/src/main/res/mipmap-*/` for each variant (`ic_launcher_balussery`, `ic_launcher_koduvalli`, `ic_launcher_perambra`)
- [x] 3.2 Add three `<activity-alias>` entries to `android/app/src/main/AndroidManifest.xml` — one per constituency, pointing to `.MainActivity`, each with its icon, initially `android:enabled="false"`
- [x] 3.3 Default `<activity>` (MainActivity) retains neutral icon and `android:enabled="true"`

## 4. AppIconService

- [x] 4.1 Create `lib/core/services/app_icon_service.dart` with static methods `setForConstituency(String? slug)` and `clearToDefault()`
- [x] 4.2 Implement slug-to-icon-name mapping: `balussery` → `balussery` (iOS) / `BalusseryAlias` (Android), etc.
- [x] 4.3 Wrap calls in try/catch; log warning on failure, never throw to caller
- [x] 4.4 Handle unknown slug: fall back to default icon and log warning
- [x] 4.5 Handle `clearToDefault()`: call `setAlternateIconName(null)` on iOS, `setIcon(null)` on Android

## 5. Wire into Controllers

- [x] 5.1 In `constituency_view.dart` — save prefs and call `AppIconService.setForConstituency(slug)` on pre-auth selection; also call after post-auth constituency save
- [x] 5.2 In `AuthController._loadUserIfLoggedIn()` — call `AppIconService.setForConstituency(slug)` after profile resolves
- [x] 5.3 In `AuthController._clearLocalSessionContext()` — call `AppIconService.clearToDefault()` after clearing prefs

## 6. Testing & Verification

- [ ] 6.1 Test on physical iOS device: select Balussery in onboarding → confirm home screen icon changes
- [ ] 6.2 Test on physical iOS device: log out → confirm icon reverts to default
- [ ] 6.3 Test on physical Android device: same flows as 6.1 and 6.2
- [ ] 6.4 Test on iOS Simulator: confirm graceful fallback (no crash) when alternate icon not supported
- [ ] 6.5 Test with unrecognized constituency slug: confirm default icon applied, no crash
- [ ] 6.6 Test cold launch with stored constituency pref: confirm icon is correct after app restart
