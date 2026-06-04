## ADDED Requirements

### Requirement: OTP send via REST API
The system SHALL send OTP requests to `POST /auth/otp/send` with phone number as payload.

#### Scenario: OTP sent successfully
- **WHEN** user submits a valid phone number
- **THEN** system calls `POST /auth/otp/send` with `{phone: '+91<number>'}` and navigates to OTP screen

#### Scenario: OTP send fails
- **WHEN** `POST /auth/otp/send` returns error or network fails
- **THEN** error snackbar shown, user stays on phone screen

### Requirement: OTP verify via REST API
The system SHALL verify OTP via `POST /auth/otp/verify` and store the returned JWT token and citizenId in secure storage.

#### Scenario: Successful OTP verification
- **WHEN** user enters correct 6-digit OTP
- **THEN** system calls `POST /auth/otp/verify` with `{phone, otp}`, stores `token` as `auth_token` and `citizenId` as `citizen_id` in FlutterSecureStorage, and proceeds to onboarding routing

#### Scenario: Failed OTP verification
- **WHEN** `POST /auth/otp/verify` returns error or invalid OTP
- **THEN** error snackbar shown, user stays on OTP screen, nothing written to storage

### Requirement: JWT token and citizenId persisted in secure storage
After successful OTP verify, the system SHALL persist `auth_token` and `citizen_id` in FlutterSecureStorage for use by the auth interceptor on all subsequent requests.

#### Scenario: Token available for next request
- **WHEN** any API request is made after login
- **THEN** `AuthInterceptor` reads `auth_token` from secure storage and injects it as Bearer token

### Requirement: Logout via REST API
The system SHALL call `POST /citizens/:citizenId/auth/logout` then clear all auth values from secure storage.

#### Scenario: Successful logout
- **WHEN** user triggers logout
- **THEN** `POST /citizens/:citizenId/auth/logout` called (best-effort), then `auth_token`, `citizen_id`, and `refresh_token` deleted from secure storage, and user navigated to welcome screen

#### Scenario: Logout when offline
- **WHEN** user triggers logout and network is unavailable
- **THEN** REST call fails silently, secure storage is still cleared, and user navigated to welcome screen
