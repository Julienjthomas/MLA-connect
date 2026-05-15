## Why

Login/onboarding flow has two critical bugs: (1) citizen data intermittently fails to load after OTP verification, causing blank screens or stale state; (2) logout from any onboarding screen always navigates to the panchayat/local-body selection screen instead of returning the user to the screen they were on. The root cause is that routing decisions are made before profile data finishes loading, and logout clears in-memory state without persisting the resume point.

## What Changes

- **On app launch**: fetch authenticated user's full profile from Supabase before routing decisions are made — no more routing on partial/empty citizen data
- **Splash routing**: after profile load, evaluate `hasCompletedOnboarding()` and route to `/home` or to the correct resume screen (whichever step is incomplete)
- **Logout from onboarding screens**: each onboarding screen persists its route before signing out; after logout, the welcome screen deep-links back to that saved route so the user resumes where they left off — not at panchayat
- **Constituency data saved per screen**: each onboarding step saves its selection to SharedPreferences immediately (constituency → local body → ward) so that on re-launch the resume route reflects real progress, not stale controller state
- **Profile re-fetch on resume**: `OnboardingController.onReady` always re-fetches profile from DB when user is authenticated, replacing the current "maybe load from prefs" logic

## Capabilities

### New Capabilities

- `auth-session-bootstrap`: Centralized profile-load-then-route logic run at splash time; guarantees citizen data exists in `AuthController.user` before any screen renders
- `onboarding-resume-routing`: Stateless resume route calculation based on persisted SharedPreferences (constituency_id, local_body_id, ward_id, name) — works across logout/login cycles
- `logout-screen-awareness`: Each onboarding screen registers its own route name before calling logout; post-logout navigation returns to that exact screen

### Modified Capabilities

- None — existing spec-level contracts unchanged; this change fixes implementation correctness

## Impact

- `AuthController` — add `bootstrapSession()` called from SplashController; `logout()` accepts optional `returnRoute` parameter
- `SplashController` — await `bootstrapSession()` before routing
- `OnboardingController` — save each selection to extended SharedPreferences keys (`local_body_id`, `ward_id`); hydrate from prefs on every onReady
- `ConstituencyPrefs` — extend to persist `local_body_id`, `local_body_name`, `ward_id`, `ward_name`
- Onboarding views (constituency, panchayat, ward, profile-setup, notifications-setup) — call `logout(returnRoute: Routes.currentScreen)` rather than plain `logout()`
- No new dependencies; no DB schema changes
