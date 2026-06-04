## MODIFIED Requirements

### Requirement: Phone OTP authentication via REST API
The system SHALL authenticate users by sending a 6-digit OTP via the REST API (`POST /auth/otp/send`), phone prefixed with `+91`.

#### Scenario: Send OTP
- **WHEN** the user submits a 10-digit Indian mobile number
- **THEN** the system calls `POST /auth/otp/send` with `{phone: '+91<number>'}` and navigates to the OTP screen

#### Scenario: Verify OTP success
- **WHEN** the user enters a valid 6-digit code
- **THEN** the system calls `POST /auth/otp/verify`, stores JWT token and citizenId in secure storage, and proceeds in the onboarding flow

#### Scenario: Verify OTP failure
- **WHEN** verify returns error or no token
- **THEN** the system shows an error and remains on the OTP screen

### Requirement: Session-aware properties from secure storage
`AuthController` SHALL expose `isLoggedIn` and `userId` derived from FlutterSecureStorage (`auth_token` and `citizen_id` keys) instead of Supabase session.

#### Scenario: Logged in
- **WHEN** `auth_token` exists in secure storage
- **THEN** `isLoggedIn` returns true and `userId` returns the stored `citizen_id`

#### Scenario: Logged out
- **WHEN** `auth_token` is absent from secure storage
- **THEN** `isLoggedIn` returns false and `userId` returns null

### Requirement: Logout clears storage and routes to welcome
`logout()` SHALL call `POST /citizens/:citizenId/auth/logout` (best-effort), delete auth keys from secure storage, clear local constituency SharedPreferences, reset in-memory onboarding state, and navigate to the welcome route.

#### Scenario: User taps Logout
- **WHEN** the user confirms the logout dialog
- **THEN** REST logout called, all auth storage cleared, constituency prefs cleared, and welcome route shown via `Get.offAllNamed`
