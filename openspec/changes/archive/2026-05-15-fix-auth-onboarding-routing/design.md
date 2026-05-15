## Context

The app uses GetX routing with `AuthController` as a permanent singleton. Currently:

- `SplashController` checks `isLoggedIn` (session cookie only) and immediately routes without awaiting the full profile load from Supabase
- `OnboardingController.onReady` conditionally loads from DB *or* SharedPreferences — the race between controller init and navigation means screens sometimes render before data arrives
- `logout()` in `AuthController` always navigates to `/welcome`, discarding where the user was in the onboarding flow
- `ConstituencyPrefs` only persists `constituency_id` and `constituency_name` — local body and ward selections are memory-only, lost on restart
- `resolveOnboardingResumeRoute()` checks `user` model fields, but if the profile fetch failed silently, all fields are null → always returns `/constituency`

## Goals / Non-Goals

**Goals:**
- Guarantee citizen data is loaded into `AuthController.user` before any routing decision at splash
- Resume route after logout returns user to the screen they were on, not always panchayat
- Each onboarding step persists its selection locally so resume route survives app kill
- Profile re-fetch on session resume is explicit and awaited, not fire-and-forget

**Non-Goals:**
- Offline mode or full local caching of citizen profile
- Changing the DB schema or Supabase RLS rules
- Altering the onboarding screen order or UI design
- Handling deep links from push notifications (separate concern)

## Decisions

### D1: Bootstrap profile load in SplashController, not OnboardingController

**Decision:** Add `AuthController.bootstrapSession()` — an async method that (if `isLoggedIn`) calls `UserService.getProfile()`, populates `user`, and returns. `SplashController` awaits it before deciding the route.

**Why:** SplashController is the single chokepoint all app launches pass through. Centralizing the await here means every downstream screen (onboarding or home) can trust `AuthController.user` is populated. Doing it in OnboardingController means the data arrives mid-render.

**Alternative considered:** Load profile in `AuthController.onInit`. Rejected because `onInit` is synchronous in GetX — you can't reliably await async work there without a `ever()`/`worker` hack that introduces its own race.

---

### D2: Extend SharedPreferences to persist local body and ward selections

**Decision:** Add `local_body_id`, `local_body_name`, `ward_id`, `ward_name` keys to `ConstituencyPrefs`. Each onboarding screen writes its selection to prefs immediately on "Continue" tap, before navigating.

**Why:** `resolveOnboardingResumeRoute()` currently checks `user` model fields. If the profile fetch fails or the user never completed onboarding (no DB row yet), this always returns `/constituency`. Persisting incrementally means the resume route is accurate even before a complete profile exists in Supabase.

**Alternative considered:** Store a single "last completed step index" integer. Rejected — fragile if steps reorder; better to persist the actual IDs which are also needed to hydrate controllers.

---

### D3: Logout accepts optional `returnRoute` parameter; persisted to SharedPreferences

**Decision:** `AuthController.logout({String? returnRoute})` saves `returnRoute` to a new `ConstituencyPrefs.pendingReturnRoute` key before signing out. After logout, `WelcomeScreen` (or the splash route after next login) reads this key and navigates there before clearing it.

**Why:** Supabase sign-out is async and clears the session — after that, the app state is fully reset. We can't pass the return route through controller state because GetX disposes controllers on sign-out. SharedPreferences survives sign-out.

**Where return route is consumed:** In `SplashController`, after `bootstrapSession()` succeeds for a partially-onboarded user, check `ConstituencyPrefs.pendingReturnRoute` first. If set and user is not fully onboarded, navigate there (then clear the key). This way the return route works even if the user relaunches the app after sign-out without immediately logging back in.

**Alternative considered:** Pass route via `Get.arguments` to `/welcome`. Rejected — welcome screen is a dead-end; user still has to tap "Sign In" and go through OTP, by which time arguments are lost.

---

### D4: `resolveOnboardingResumeRoute` reads from extended prefs, not only user model

**Decision:** Rewrite resume logic to check in order: pending return route (from D3) → prefs `ward_id` → prefs `local_body_id` → prefs `constituency_id` → `/constituency`. Fall back to user model fields only if prefs are empty (for existing users who never had prefs written).

**Why:** Prefs are written eagerly per-step; user model is written only on `saveProfile()` (final step). Using prefs gives finer granularity and survives profile-fetch failures.

## Risks / Trade-offs

- **Bootstrap adds splash delay** → Mitigation: `bootstrapSession()` only runs when `isLoggedIn`; cold starts (no session) are unaffected. Profile fetch is a single Supabase query, typically <200ms on good connectivity.
- **SharedPreferences stale after account switch** → Mitigation: `clearLocalConstituencyState()` (already called on logout) will be extended to also clear the new keys, so a second user on the same device starts fresh.
- **`pendingReturnRoute` persists if user uninstalls mid-flow** → Acceptable; on reinstall there is no Supabase session so it is ignored.
- **GetX controller lifecycle** → `OnboardingController` may be recreated after logout/login cycle. Ensure it re-hydrates from prefs in `onReady`, not from stale in-memory state.

## Migration Plan

1. Ship changes behind the existing auth flow — no feature flag needed (bug fix)
2. `ConstituencyPrefs` new keys default to `null`; existing users without them fall back to user model → no migration needed
3. No DB changes → no rollback risk on backend
4. Rollback: revert the three controller changes; prefs keys left behind are harmless
