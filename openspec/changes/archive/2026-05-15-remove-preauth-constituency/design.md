## Context

Onboarding currently asks for constituency selection before login (preAuth mode), saves to local prefs, then re-asks after OTP if the profile has no `constituencyId`. The `_syncConstituencyFromPrefsIfNeeded()` function was intended to bridge this gap but the result is users seeing the same screen twice.

Post-OTP, `resolveOnboardingResumeRoute()` already correctly routes new users to `Routes.constituency` when `profile.constituencyId == null`. No new routing logic is needed.

## Goals / Non-Goals

**Goals:**
- Single constituency selection, post-login only
- Remove all preAuth-mode code paths

**Non-Goals:**
- Changing the constituency selection UI itself
- Changing panchayat/ward/profile steps
- Handling returning users differently (already works correctly)

## Decisions

**Remove `_syncConstituencyFromPrefsIfNeeded()` entirely** — with no pre-auth selection, there are no prefs to sync. Keeping it would be dead code. The function's two call sites (`onInit` auth state listener and `verifyOtp`) both drop the call.

**Remove `_isPreAuth` getter and branch in `ConstituencyView`** — the `preAuth` code path (save to prefs only, navigate to phone) is no longer reachable. Removing it simplifies the view to a single behavior: always post-auth, always saves to profile and navigates to panchayat.

**`ConstituencyPrefs` stays** — still used by `OnboardingController._hydrateFromPrefs()` to restore selection state between sessions for logged-in users. Not dead code.

## Risks / Trade-offs

- **Users who had a pre-auth constituency saved in prefs**: On their next session, `_hydrateFromPrefs` still runs but `_syncConstituencyFromPrefsIfNeeded` won't auto-save it. They'll just go through constituency selection once post-login, which is the desired behavior.
- No migration needed — purely a UI flow simplification with no data model changes.
