## Why

The app serves multiple constituencies (Balussery, Koduvalli, Perambra) but shows a single identity regardless of context. Users in each constituency should feel the app belongs to them — with a distinct launcher icon and app name that reflects their constituency when one is selected, falling back to the neutral "Ente MLA" identity when no constituency is set (pre-auth, logged out).

## What Changes

- When no constituency is selected (logged out / pre-auth), app shows neutral identity: name "Ente MLA", generic launcher icon.
- When constituency is known (selected pre-auth or from logged-in profile), app shows constituency-specific identity: name "Super Balussery" / "Ente MLA Koduvalli" / "Ente MLA Perambra" and a matching launcher icon variant.
- Launcher icon swap at runtime using platform-specific alternate icon APIs (iOS `setAlternateIconName`, Android activity-alias technique).
- App name change at runtime is **not possible natively** — the in-app title (`GetMaterialApp.title`) and splash/onboarding branding will reflect the constituency name instead as the practical substitute.

## Capabilities

### New Capabilities
- `dynamic-app-icon`: Select and apply a constituency-specific launcher icon at runtime based on stored constituency selection; fall back to default icon when no constituency is active.

### Modified Capabilities
- `multi-constituency-branding`: Extend existing branding spec to cover launcher icon surface (in addition to in-app name/subtitle already specified). Requirement: launcher icon SHALL reflect active constituency.

## Impact

- `lib/core/services/app_icon_service.dart` — new service wrapping platform channel for icon switching
- `lib/features/onboarding/controllers/onboarding_controller.dart` — trigger icon switch on constituency selection
- `lib/features/auth/controllers/auth_controller.dart` — trigger icon switch on login (profile resolved) and clear on logout
- `android/app/src/main/AndroidManifest.xml` — add activity-alias entries per constituency icon
- `android/app/src/main/res/` — add mipmap icon sets per constituency
- `ios/Runner/` — add alternate icon sets in `Assets.xcassets` and declare in `Info.plist`
- New Flutter package dependency: `dynamic_icon_flutter` or `flutter_dynamic_icon` for cross-platform icon switching
