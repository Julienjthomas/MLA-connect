## Context

Constituency selection during pre-auth onboarding is persisted in SharedPreferences via `ConstituencyPrefs` (`constituency_id`, `constituency_name`). `OnboardingController` is registered with `permanent: true` and loads the saved name on init; `WelcomeView` displays that value when non-empty. `AuthController.logout()` signs out of Supabase, nulls `user`, and navigates to welcome but does not clear prefs or reset onboarding state. The `signedOut` auth listener also only nulls `user`. After logout, welcome and splash can still show the previous constituency, and `_syncConstituencyFromPrefsIfNeeded` can write that selection onto a newly authenticated profile.

## Goals / Non-Goals

**Goals:**

- End every session with no local constituency id/name and no stale in-memory onboarding selection.
- Show generic Ente MLA branding on welcome and splash for logged-out users until they select a constituency again.
- Keep post-OTP sync from prefs for users who selected a constituency in the same pre-auth session without logging out.
- Handle both explicit logout and external `signedOut` events through one code path.

**Non-Goals:**

- Clearing server-side `citizens.constituency_id` on logout (profile data remains for the same account on re-login).
- Clearing unrelated prefs (locale, notification tokens, etc.).
- Changing the onboarding route order or constituency picker UX beyond removing stale pre-selection.

## Decisions

**Centralize session teardown in `AuthController`**

- Add a private `_clearLocalSessionContext()` that calls `ConstituencyPrefs.clear()`, resets `OnboardingController` when registered, and nulls `user`.
- Invoke it from `logout()` before navigation and from the `signedOut` branch of `onAuthStateChange` so token expiry and remote sign-out match explicit logout.
- *Alternative:* Clear only in profile logout — rejected because external sign-out would leave stale prefs.

**Reset onboarding state via a dedicated controller method**

- Add `OnboardingController.clearLocalConstituencyState()` to clear `savedConstituencyName`, `selectedConstituency`, local bodies, wards, and search fields without deleting the permanent controller.
- *Alternative:* `Get.delete<OnboardingController>(force: true)` on logout — rejected because bindings may not re-run before welcome renders, causing a race on `savedConstituencyName`.

**Welcome branding when prefs are empty**

- Keep existing welcome logic: empty saved name shows the Ente MLA label; no new copy changes required once prefs and controller state are cleared.

**Splash subtitle for logged-out cold start**

- `SplashController` already falls back to prefs only when profile name is absent; after prefs clear, logged-out users get the generic tagline per `multi-constituency-branding`.

**Constituency picker hydration**

- `_hydrateFromPrefs` already skips when `auth.userId != null` or `selectedConstituency` is set; after logout reset, an unauthenticated user with empty prefs sees no pre-selected row.

## Risks / Trade-offs

- **[Risk] User logs out mid pre-auth onboarding and must re-pick constituency** → Expected: constituency is session-scoped for anonymous onboarding; clearing on logout avoids cross-account leakage.
- **[Risk] `OnboardingController` not registered when `signedOut` fires** → Mitigation: guard with `Get.isRegistered<OnboardingController>()` before reset.
- **[Risk] Duplicate clear if both `logout()` and `signedOut` run** → Mitigation: idempotent `ConstituencyPrefs.clear()` and controller reset.
