## ADDED Requirements

### Requirement: Phone OTP authentication via Supabase
The system SHALL authenticate users by sending a 6-digit OTP via Supabase Auth's phone provider, prefixed with `+91`.

#### Scenario: Send OTP
- **WHEN** the user submits a 10-digit Indian mobile number
- **THEN** the system calls `Supabase.auth.signInWithOtp(phone: '+91<number>')` and navigates to the OTP screen

#### Scenario: Verify OTP success
- **WHEN** the user enters a valid 6-digit code
- **THEN** the system calls `verifyOTP` with `OtpType.sms` and proceeds in the onboarding flow if a session is returned

#### Scenario: Verify OTP failure
- **WHEN** verification throws or returns no session
- **THEN** the system shows an error and remains on the OTP screen

### Requirement: Permanent AuthController service
A single `AuthController` instance SHALL be registered with `Get.put(..., permanent: true)` before `GetMaterialApp` and survive all route changes.

#### Scenario: Cross-feature access
- **WHEN** any feature controller calls `Get.find<AuthController>()`
- **THEN** the same instance is returned

### Requirement: Session-aware properties
`AuthController` SHALL expose `isLoggedIn` and `userId` derived from `Supabase.instance.client.auth.currentSession`.

#### Scenario: Logged in
- **WHEN** a Supabase session exists
- **THEN** `isLoggedIn` returns true and `userId` returns the session user's id

### Requirement: Auth state subscription
The `AuthController` SHALL subscribe to `auth.onAuthStateChange` to refresh `user` on `signedIn` and clear local session context on `signedOut`.

#### Scenario: External sign-out
- **WHEN** the Supabase client emits `AuthChangeEvent.signedOut`
- **THEN** local constituency prefs are cleared, onboarding constituency state is reset when registered, and `user.value` becomes null

### Requirement: Logout clears session and routes to welcome
`logout()` SHALL call `auth.signOut()`, clear local constituency SharedPreferences, reset in-memory onboarding constituency state when `OnboardingController` is registered, null the cached user, and navigate to the welcome route.

#### Scenario: User taps Logout
- **WHEN** the user confirms the logout dialog on the profile tab
- **THEN** the session is signed out, local constituency prefs are cleared, onboarding constituency state is reset, and the welcome route is shown via `Get.offAllNamed`
