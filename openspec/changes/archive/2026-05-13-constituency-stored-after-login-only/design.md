## Context

Current flow:
1. Pre-auth: user taps constituency → `ConstituencyPrefs.save(id, name)` written to disk
2. User kills app
3. Cold launch: no session → `OnboardingController._loadSavedConstituencyName()` reads prefs → `savedConstituencyName` populated
4. Splash/welcome read `savedConstituencyName` or `constituencyName` → shows constituency name as primary title
5. Bug: generic "MLA Connect" never shown

Correct flow:
1. Pre-auth: user taps constituency → stored only in `OnboardingController.selectedConstituency` (in-memory Rx)
2. User kills app → in-memory gone, prefs empty
3. Cold launch: prefs empty → `savedConstituencyName` stays `''` → splash shows "MLA Connect"
4. On `signedIn` event: `_syncConstituencyFromPrefsIfNeeded` is no-op (no prefs) — that's OK, the constituency was already attached to the profile during the OTP verify flow via `_loadUserIfLoggedIn`

## Goals / Non-Goals

**Goals:**
- Generic splash on cold launch without session
- Pre-auth constituency selection still works (in-memory is enough — it's read during the same onboarding session)

**Non-Goals:**
- Changing post-login constituency persistence (still write prefs after login for hydration)
- Changing the `_syncConstituencyFromPrefsIfNeeded` sync logic

## Decisions

**Remove only the pre-auth `ConstituencyPrefs.save` call** — minimal change, single line deletion in `constituency_view.dart`. No controller changes needed.

The in-memory `selectedConstituency` on `OnboardingController` is already the source of truth during onboarding. It's read by `profile_setup_controller.dart` and `auth_controller.saveProfile`. Removing the prefs write doesn't break constituency handoff to the profile.

**Keep `_hydrateFromPrefs` as-is** — after login, if prefs exist (legacy users or future post-login writes), it still hydrates correctly. With pre-auth write gone it just becomes a no-op for new sessions.

## Risks / Trade-offs

- If someone was relying on prefs to restore selection after kill during onboarding: they now have to re-select. This is intentional — the tradeoff is correct UX on cold launch vs minor inconvenience on resume.
- `_syncConstituencyFromPrefsIfNeeded` becomes effectively dead for new users (no pre-auth prefs to sync). Low risk; the constituency is already on the profile by `saveProfile` time.

## Migration Plan

1. Delete `ConstituencyPrefs.save(id: c.id, name: c.name)` in `constituency_view.dart` pre-auth branch
2. Hot restart — verify splash shows "MLA Connect" after kill+relaunch
