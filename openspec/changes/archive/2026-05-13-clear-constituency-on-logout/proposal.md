## Why

Pre-auth constituency selection is stored in SharedPreferences and mirrored in the permanent `OnboardingController`. Logout only clears the Supabase session and cached profile, so a logged-out user still sees the previous constituency (for example Balussery) on the welcome screen, splash subtitle, and constituency picker. That breaks the logged-out experience and can attach the next account to the wrong assembly constituency during OTP sync.

## What Changes

- Clear local constituency id and name from SharedPreferences whenever the session ends through explicit logout or Supabase `signedOut`.
- Reset in-memory onboarding constituency state (`savedConstituencyName`, selected constituency, and dependent local-body/ward selections) so welcome and pre-auth onboarding do not show stale branding.
- Route logged-out users to a neutral welcome experience (generic Ente MLA branding) until they choose a constituency again.
- Audit splash, welcome, constituency picker hydration, and post-OTP constituency sync so no logged-out surface reads stale prefs.

## Capabilities

### New Capabilities

_None._

### Modified Capabilities

- `auth`: Logout and external sign-out clear local constituency selection and reset onboarding constituency state before routing to welcome.
- `onboarding`: Logged-out welcome and pre-auth flows do not display or pre-select a constituency from a prior session.
- `multi-constituency-branding`: Splash and welcome branding rules apply after logout; stale constituency prefs must not drive subtitles or headings.

## Impact

- `lib/features/auth/controllers/auth_controller.dart` (`logout`, `onAuthStateChange` signedOut handler)
- `lib/core/utils/constituency_prefs.dart` (existing `clear()` helper)
- `lib/features/onboarding/controllers/onboarding_controller.dart` (in-memory reset API)
- `lib/features/onboarding/views/welcome_view.dart` (reads `savedConstituencyName`)
- `lib/features/onboarding/controllers/splash_controller.dart` (prefs fallback for subtitle)
- `lib/features/onboarding/views/constituency_view.dart` and `_hydrateFromPrefs` (pre-selection from prefs)
- Post-auth `_syncConstituencyFromPrefsIfNeeded` in `AuthController` (must not consume stale prefs after logout)
