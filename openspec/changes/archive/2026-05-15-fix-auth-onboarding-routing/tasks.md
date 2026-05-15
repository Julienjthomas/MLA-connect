## 1. Extend ConstituencyPrefs

- [x] 1.1 Add `local_body_id`, `local_body_name`, `ward_id`, `ward_name`, `pending_return_route` keys to `ConstituencyPrefs` in `lib/core/utils/constituency_prefs.dart`
- [x] 1.2 Add `saveLocalBody(String id, String name)` and `saveWard(String id, String name)` methods to `ConstituencyPrefs`
- [x] 1.3 Add `savePendingReturnRoute(String route)`, `getPendingReturnRoute()`, and `clearPendingReturnRoute()` methods to `ConstituencyPrefs`
- [x] 1.4 Update `ConstituencyPrefs.clear()` to also delete the new keys (local body, ward, pending return route)

## 2. AuthController — bootstrapSession

- [x] 2.1 Add `bootstrapSession()` async method to `AuthController` (`lib/features/auth/controllers/auth_controller.dart`) that calls `UserService.getProfile(userId)` if `isLoggedIn`, catches errors, and populates `user`
- [x] 2.2 Update `resolveOnboardingResumeRoute()` to read prefs in order (ward_id → local_body_id → constituency_id → name) before falling back to user model fields
- [x] 2.3 In `resolveOnboardingResumeRoute()`, after computing the resume route, check `ConstituencyPrefs.getPendingReturnRoute()` — if set and user is not fully onboarded, return that route instead (then clear it)
- [x] 2.4 Update `logout()` to accept optional `returnRoute` parameter; if provided (and non-null), call `ConstituencyPrefs.savePendingReturnRoute(returnRoute)` before signing out
- [x] 2.5 Verify `_clearLocalSessionContext()` calls the updated `ConstituencyPrefs.clear()` so all new keys are wiped on logout

## 3. SplashController — await bootstrap before routing

- [x] 3.1 In `SplashController` (`lib/features/onboarding/controllers/splash_controller.dart`), replace the synchronous `isLoggedIn` check with an `await AuthController.find.bootstrapSession()` call before routing logic runs
- [x] 3.2 After `bootstrapSession()`, read `ConstituencyPrefs.getPendingReturnRoute()` — if set and user is not fully onboarded, navigate there and clear the key; otherwise follow normal routing logic
- [x] 3.3 If `pending_return_route` exists but user IS fully onboarded, clear the stale key and navigate to `/home`

## 4. Onboarding screens — persist selections eagerly

- [x] 4.1 In `OnboardingController.selectConstituency()` (`lib/features/onboarding/controllers/onboarding_controller.dart`), call `ConstituencyPrefs.save()` immediately after selection (already done for constituency; verify it fires before navigation)
- [x] 4.2 In `OnboardingController.selectLocalBody()`, call `ConstituencyPrefs.saveLocalBody(id, name)` immediately after selection
- [x] 4.3 In `OnboardingController.selectWard()` (or wherever ward confirmation happens), call `ConstituencyPrefs.saveWard(id, name)` immediately after selection
- [x] 4.4 In `OnboardingController.onReady`, always re-hydrate from prefs when `isLoggedIn` (remove the conditional that skips prefs load when user data is present)

## 5. Onboarding views — logout with return route

- [x] 5.1 In `ConstituencyView` (`lib/features/onboarding/views/constituency_view.dart`), update any logout action to call `AuthController.find.logout(returnRoute: Routes.constituency)`
- [x] 5.2 In `PanchayatView` (`lib/features/onboarding/views/panchayat_view.dart`), update any logout action to call `AuthController.find.logout(returnRoute: Routes.panchayat)`
- [x] 5.3 In `WardView` (`lib/features/onboarding/views/ward_view.dart`), update any logout action to call `AuthController.find.logout(returnRoute: Routes.ward)`
- [x] 5.4 In `ProfileSetupView` (`lib/features/auth/views/profile_setup_view.dart`), update any logout action to call `AuthController.find.logout(returnRoute: Routes.profileSetup)`
- [x] 5.5 Verify home/profile screen logout calls remain plain `AuthController.find.logout()` with no `returnRoute`

## 6. Verification

- [ ] 6.1 Manual test: fresh install → complete full onboarding → verify home screen loads with correct citizen data
- [ ] 6.2 Manual test: partial onboarding (stop at panchayat) → kill app → relaunch → verify resume lands on panchayat screen with data pre-loaded
- [ ] 6.3 Manual test: logout from ward screen → log back in → verify return to ward screen (not panchayat)
- [ ] 6.4 Manual test: logout from home → log back in → verify lands on home (not onboarding)
- [ ] 6.5 Manual test: poor network at splash → verify app doesn't hang or crash when profile fetch fails

