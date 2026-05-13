## 1. Session teardown

- [x] 1.1 Add `AuthController._clearLocalSessionContext()` that calls `ConstituencyPrefs.clear()`, resets `OnboardingController` when registered, and nulls `user`
- [x] 1.2 Call `_clearLocalSessionContext()` from `logout()` before `Get.offAllNamed(Routes.welcome)`
- [x] 1.3 Call `_clearLocalSessionContext()` from the `AuthChangeEvent.signedOut` branch of `onAuthStateChange`

## 2. Onboarding state reset

- [x] 2.1 Add `OnboardingController.clearLocalConstituencyState()` to clear `savedConstituencyName`, `selectedConstituency`, local bodies, wards, and related search/loading fields
- [x] 2.2 Ensure welcome and constituency picker read empty state after logout (no stale `savedConstituencyName` or pre-selected row)

## 3. Verification

- [x] 3.1 Manual: log in with a constituency, log out, confirm welcome shows Ente MLA and constituency picker has no pre-selection
- [x] 3.2 Manual: after logout, cold relaunch and confirm splash subtitle is the generic tagline
- [x] 3.3 Manual: select constituency pre-auth, complete OTP in the same session, confirm profile still receives constituency sync from prefs
