## Why

Dynamic app icon switching per constituency adds significant native complexity (Android activity-alias, iOS alternate icons, method channel, lifecycle hooks) with little user value — the feature changes the launcher icon based on the selected constituency, but users rarely notice or need this. Removing it simplifies the codebase and eliminates a class of hard-to-debug issues around alias state management.

## What Changes

- Delete `AppIconService` (Flutter service with MethodChannel)
- Remove `AppIconService` calls from `auth_controller.dart` (login/logout flows) and `constituency_view.dart` (onboarding selection)
- Remove `applyPendingAndroid` lifecycle hook from `main.dart`
- Remove Android activity-alias entries (`DefaultAlias`, `BalusseryAlias`, `KoduvalliAlias`, `PerambraAlias`) from `AndroidManifest.xml` and restore direct `LAUNCHER` intent-filter on `MainActivity`
- Remove `setIcon` MethodChannel handler from `MainActivity.kt`
- Remove `CFBundleAlternateIcons` block from `ios/Runner/Info.plist`
- Remove `setIcon` MethodChannel handler from `AppDelegate.swift`
- Delete alternate icon asset directories (iOS `AlternateIcons/`, Android `ic_launcher_*` mipmaps)

## Capabilities

### New Capabilities
<!-- none -->

### Modified Capabilities
<!-- none — no spec-level behavior changes, purely removing an internal feature -->

## Impact

- **Flutter**: `lib/core/services/app_icon_service.dart` deleted; 3 call-sites cleaned up in `auth_controller.dart`, `constituency_view.dart`, `main.dart`
- **Android**: `AndroidManifest.xml` (main only; debug/profile already omit aliases), `MainActivity.kt`
- **iOS**: `Info.plist`, `AppDelegate.swift`, alternate icon image assets
- **No API or data model changes**
