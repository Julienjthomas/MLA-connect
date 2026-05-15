## Context

The app currently has a single launcher icon and a hardcoded `GetMaterialApp.title` of "Ente MLA". Constituency identity is stored in `SharedPreferences` (via `ConstituencyPrefs`) and is available both pre-auth (user picked constituency on onboarding picker) and post-auth (from `UserModel.constituencyId` resolved via `ConstituencyDbId`). The three constituencies are `balussery`, `koduvalli`, `perambra` (known slugs from `ConstituencySeed`).

Runtime launcher icon changes are a platform-specific feature:
- **iOS**: Supports alternate app icons via `UIApplication.setAlternateIconName()`. Icons declared in `Info.plist` under `CFBundleIcons.CFBundleAlternateIcons`. Works on iOS 10.3+.
- **Android**: Supports icon switching via activity-alias entries with `android:enabled` toggled at runtime via `PackageManager.setComponentEnabledSetting()`. Requires a brief app restart perception — the icon changes after the user re-views their home screen.

Runtime app name change is **not supported** natively on either platform without reinstall or OS-level tricks. We scope this out.

## Goals / Non-Goals

**Goals:**
- Launcher icon reflects active constituency (balussery, koduvalli, perambra) or falls back to default neutral icon when no constituency is active
- Icon switch triggers at three points: constituency selected during onboarding, profile resolved on login, constituency cleared on logout
- Flutter service layer abstracts platform differences; callers only call `AppIconService.setConstituency(slug)` or `AppIconService.clearConstituency()`
- In-app title/branding on splash continues to show constituency name (already handled by `multi-constituency-branding`)

**Non-Goals:**
- Runtime app name change on home screen (impossible without reinstall)
- Custom icon per ward or local body (only per constituency)
- Animated or transitional icon effects
- Changing icon for the currently visible task switcher entry (OS limitation)

## Decisions

### D1: Package — `flutter_dynamic_icon` over custom platform channel

`flutter_dynamic_icon` (pub.dev) wraps both `setAlternateIconName` (iOS) and the activity-alias pattern (Android) behind a single Dart API. Writing a custom method channel would require the same native code with no benefit. The package is well-maintained and used in production apps.

Alternatives considered:
- Custom `MethodChannel`: More control but duplicates what the package already does correctly.
- `dynamic_icon_flutter`: Less maintained, fewer stars, no Android support verified.

### D2: Android icon-switching via activity-alias (not shortcut icons)

Android doesn't have a first-class alternate icon API like iOS. The standard approach is declaring one `<activity-alias>` per constituency in `AndroidManifest.xml`, each pointing to the same `.MainActivity` but with a different `android:icon`. At runtime, enable one alias and disable all others via `PackageManager`. This causes a ~1s home-screen refresh delay — acceptable.

Alternative: Adaptive icon with runtime-swapped foreground drawable — not supported by the OS without a full reinstall.

### D3: Icon switch point — `AppIconService` called from controllers, not UI

`OnboardingController` and `AuthController` already own the constituency-selected lifecycle events. Placing the call there keeps UI layers free of platform side-effects and matches the existing pattern for `ConstituencyPrefs.save/clear`.

### D4: Three constituency icon sets + one default

Icons needed:
- `default` — neutral Ente MLA icon (existing launcher icon)
- `balussery` — Super Balussery branded icon
- `koduvalli` — Koduvalli branded icon
- `perambra` — Perambra branded icon

Icon assets need to be provided as image files (designer deliverable). Placeholder: use tinted version of default icon. The service maps slug → icon name.

### D5: Graceful degradation on unsupported platforms / errors

If `setAlternateIconName` throws (e.g., simulator, permission denied, unknown slug), catch and log — do not crash. The app remains fully functional with the default icon.

## Risks / Trade-offs

- **Android UX jank**: Enabling/disabling activity-aliases causes Android to briefly remove and re-add the app shortcut on the home screen. → Acceptable; only happens on constituency change (rare event).
- **iOS requires explicit icon asset declaration**: Every icon variant must be in `Assets.xcassets` and listed in `Info.plist` before the app is submitted. Cannot add icons dynamically after install. → All three constituency icons must ship in every build.
- **Icon assets are designer deliverables**: Implementation can proceed with placeholder tinted icons; final assets must be substituted before production release.
- **`flutter_dynamic_icon` Android support**: Package uses reflection-based manifest parsing on Android — test thoroughly on API 29+.

## Migration Plan

1. Add `flutter_dynamic_icon` to `pubspec.yaml`
2. Add icon assets for all four variants (default + 3 constituencies)
3. Configure iOS `Info.plist` with alternate icon declarations
4. Configure Android `AndroidManifest.xml` with activity-alias entries per constituency
5. Implement `AppIconService` in `lib/core/services/`
6. Wire calls in `OnboardingController.setConstituency()` and `AuthController._loadUserIfLoggedIn()` / `_clearLocalSessionContext()`
7. Test on physical device (simulator does not support alternate icons on iOS)

No database migration needed. No rollback risk — worst case, icon stays as default.

## Open Questions

- **Icon designs**: Who provides constituency-specific icon artwork? (Blocking for production; placeholder approach unblocks dev)
- **App name on home screen**: Product decision — is "Ente MLA" acceptable for all constituencies, or does Balussery specifically want "Super Balussery" as the home screen label? (If yes, requires separate build flavors — much higher complexity.)
