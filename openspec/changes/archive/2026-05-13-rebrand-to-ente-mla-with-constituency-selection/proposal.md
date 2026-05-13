## Why

The app is hardcoded for "Super Balussery" — name, splash, and strings all assume a single constituency. To make this a generic "Ente MLA" platform usable by any MLA office, users must select their constituency during onboarding, and the app must rebrand accordingly.

## What Changes

- App name changes from "Super Balussery" to "Ente MLA" across all surfaces (splash, app bar, strings, about, success screen)
- Constituency selection becomes a mandatory first onboarding step (before phone auth)
- Selected constituency name appears as subtitle/tagline on splash and home
- All hardcoded "Balussery" references in strings, UI, and copy are replaced with the dynamically selected constituency name
- Constituency persists after selection — picker is not shown again on subsequent launches unless user resets

## Capabilities

### New Capabilities
- `multi-constituency-branding`: Dynamic app branding based on selected constituency — splash, home header, and tagline reflect the chosen constituency name rather than hardcoded values

### Modified Capabilities
- `onboarding`: Constituency selection screen moves to before phone auth; flow becomes: constituency → phone → OTP → panchayat → ward → profile → notifications → success
- `shell-navigation`: Home header/tagline must display selected constituency name dynamically

## Impact

- `lib/core/constants/app_strings.dart` — remove hardcoded "Super Balussery" / "Balussery" strings; add constituency-aware getters
- `lib/features/onboarding/views/splash_view.dart` — replace hardcoded name with "Ente MLA" and dynamic constituency subtitle
- `lib/features/onboarding/views/constituency_view.dart` — make this the first screen (before auth)
- `lib/routes/app_pages.dart` / `app_routes.dart` — reorder routes so constituency is first after splash
- `lib/features/auth/controllers/auth_controller.dart` — check constituency selection before allowing auth flow
- `lib/features/shell/` — home view reads constituency from user profile for dynamic display
- `android/app/src/main/res/` and `ios/` — app display name updated to "Ente MLA"
- `pubspec.yaml` — no dependency changes needed
