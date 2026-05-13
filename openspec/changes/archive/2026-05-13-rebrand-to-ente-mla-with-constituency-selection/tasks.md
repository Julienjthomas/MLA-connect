## 1. App Rename — "Ente MLA"

- [x] 1.1 Update `AppStrings.appName` from "Super Balussery" to "Ente MLA" in `lib/core/constants/app_strings.dart`
- [x] 1.2 Update `AppStrings.tagline` to "Your MLA. Your Voice." and remove hardcoded "Balussery Constituency" / "Powered for" strings
- [x] 1.3 Update `AppStrings.aboutApp` and `AppStrings.allSetSubtitle` to reference "Ente MLA"
- [x] 1.4 Rewrite `SplashView` to show "Ente MLA" as primary heading (replace "Super Balussery" RichText)
- [x] 1.5 Update Android app display name in `android/app/src/main/res/values/strings.xml`
- [x] 1.6 Update iOS app display name in `ios/Runner/Info.plist` (`CFBundleDisplayName` / `CFBundleName`)

## 2. Constituency Local Persistence

- [x] 2.1 Add `shared_preferences` to `pubspec.yaml` if not already present
- [x] 2.2 Create `lib/core/utils/constituency_prefs.dart` — a utility class with `save(id, name)`, `getId()`, `getName()`, and `clear()` methods using SharedPreferences keys `constituency_id` and `constituency_name`

## 3. Pre-Auth Constituency Picker

- [x] 3.1 Add a `mode` parameter (or `Get.arguments` flag) to `ConstituencyView` to distinguish pre-auth vs post-auth modes
- [x] 3.2 In pre-auth mode: on "Next" tap, call `ConstituencyPrefs.save()` then navigate to `Routes.phone`
- [x] 3.3 In pre-auth mode: pre-populate selected constituency from `ConstituencyPrefs` if already saved (so returning-before-auth users see their prior choice)
- [x] 3.4 Update `WelcomeView` "Continue with Phone Number" button to navigate to `Routes.constituency` (with pre-auth flag) instead of `Routes.phone`

## 4. Post-Auth Constituency Sync

- [x] 4.1 In `AuthController.verifyOtp()` success path (or in `_loadUserIfLoggedIn`): if profile has no `constituencyId` and `ConstituencyPrefs.getId()` is non-null, write the prefs constituency to the profile via `UserService.saveConstituencySelection()`
- [x] 4.2 Ensure `resolveOnboardingResumeRoute()` logic remains unchanged (already returns `Routes.constituency` only when `constituencyId == null` — this will now be satisfied by sync in 4.1)

## 5. Dynamic Splash Subtitle

- [x] 5.1 In `SplashController.onInit()`, read constituency name from `ConstituencyPrefs` (falling back to user profile if logged in) and expose as `RxString constituencyName`
- [x] 5.2 Update `SplashView` to bind to `controller.constituencyName` — show "{name} Constituency" if set, else show "Your MLA. Your Voice."

## 6. Home Header Dynamic Constituency

- [x] 6.1 Identify where the MLA banner / home header subtitle is rendered in `lib/features/shell/` or `lib/features/home/`
- [x] 6.2 Replace any hardcoded "Balussery" in the home header with `AuthController.user.value?.constituencyName` (or resolved from constituency model)
- [x] 6.3 Add graceful fallback (empty / hide subtitle) when constituency name is null

## 7. Audit & Cleanup

- [x] 7.1 Grep entire `lib/` for literal "Balussery" and "Super Balussery" — fix any remaining occurrences
- [x] 7.2 Verify `ConstituencyView` in post-auth resume mode (e.g. mid-onboarding resume) still navigates correctly to `Routes.panchayat`
- [x] 7.3 Test full new-user flow: splash → welcome → constituency picker → phone → OTP → panchayat → ward → profile → notifications → home
- [x] 7.4 Test returning user: launch with existing profile — constituency picker skipped, home shows correct constituency name
