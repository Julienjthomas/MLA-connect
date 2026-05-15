## Why

`ConstituencyPrefs` (SharedPreferences) is written during the pre-auth constituency picker, before login. If the user selects a constituency then kills the app, those prefs survive cold launch. On next launch the splash shows the constituency name as the primary title instead of "MLA Connect", even though no session exists. Constituency is transient intent during onboarding — it should only be persisted once login succeeds and the profile row is written.

## What Changes

- Remove `ConstituencyPrefs.save(...)` call from `constituency_view.dart` (pre-auth path).
- Keep in-memory `selectedConstituency` on `OnboardingController` as the sole carrier of pre-auth selection (already works — it's `Rx`, just not persisted).
- `_syncConstituencyFromPrefsIfNeeded` in `AuthController` (called on `signedIn`) already reads prefs and writes to profile — this can remain but will now only trigger if prefs exist from a post-login save.
- After successful login + profile save (post-auth constituency change), `ConstituencyPrefs.save` may still be called to aid profile hydration on next cold launch (already-logged-in users). This is fine — those prefs are tied to an active session and cleared on `signedOut`.
- Splash and welcome views show "MLA Connect" (generic) when no session exists — no change needed there since the fix is at source.

## Capabilities

### New Capabilities

None.

### Modified Capabilities

- `multi-constituency-branding`: Splash SHALL show "MLA Connect" (generic) on cold launch when no active session, regardless of any prior constituency selection in the picker.
- `onboarding`: Pre-auth constituency selection is transient (in-memory only). SharedPreferences write is deferred until after successful authentication.

## Impact

- `lib/features/onboarding/views/constituency_view.dart` — remove pre-auth `ConstituencyPrefs.save` call
- `lib/features/auth/controllers/auth_controller.dart` — `_syncConstituencyFromPrefsIfNeeded` still reads prefs but source of pre-auth prefs is removed, so it effectively becomes no-op for new users; no change needed
- `lib/features/onboarding/controllers/onboarding_controller.dart` — `_hydrateFromPrefs` reads prefs; with no pre-auth write this path only fires for logged-in users (benign)
