## Why

First-time users are asked to select their constituency twice: once before login (on the Welcome screen) and again after OTP verification. The pre-auth selection serves no functional purpose since it can't be saved to the user profile until authentication completes.

## What Changes

- Remove the constituency selection step from the pre-login flow (Welcome → Phone directly)
- Remove the `preAuth` branch logic from `ConstituencyView`
- Remove `_syncConstituencyFromPrefsIfNeeded()` from `AuthController` (dead code after this change)
- Constituency selection now happens exclusively post-OTP, driven by `resolveOnboardingResumeRoute()`

## Capabilities

### New Capabilities
- None

### Modified Capabilities
- `onboarding-flow`: Onboarding route sequence changes — constituency step moves to post-auth only

## Impact

- `lib/features/onboarding/views/welcome_view.dart` — button navigates to `Routes.phone` instead of `Routes.constituency`
- `lib/features/onboarding/views/constituency_view.dart` — remove `_isPreAuth` getter and pre-auth branch in `Next` handler
- `lib/features/auth/controllers/auth_controller.dart` — remove `_syncConstituencyFromPrefsIfNeeded()` and its two call sites
