## 1. Welcome Screen

- [x] 1.1 In `welcome_view.dart`, change button `onPressed` to navigate to `Routes.phone` instead of `Routes.constituency` with `preAuth:true` arguments

## 2. Constituency View Cleanup

- [x] 2.1 In `constituency_view.dart`, remove `_isPreAuth` getter
- [x] 2.2 In `constituency_view.dart`, remove the `if (_isPreAuth)` branch in the `Next` button handler (lines that save to prefs, set app icon, and navigate to phone)

## 3. Auth Controller Cleanup

- [ ] 3.1 In `auth_controller.dart`, remove `_syncConstituencyFromPrefsIfNeeded()` method
- [ ] 3.2 In `auth_controller.dart`, remove the call to `_syncConstituencyFromPrefsIfNeeded()` in the `onInit` auth state change listener
- [ ] 3.3 In `auth_controller.dart`, remove the call to `_syncConstituencyFromPrefsIfNeeded()` in `verifyOtp()`
