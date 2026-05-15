# logout-screen-awareness Specification

## Purpose
TBD - created by archiving change fix-auth-onboarding-routing. Update Purpose after archive.
## Requirements
### Requirement: Onboarding screens register return route before logout
Each onboarding screen that offers a logout action SHALL persist the current screen's route name to SharedPreferences as `pending_return_route` before calling `AuthController.logout()`.

#### Scenario: Logout from constituency screen
- **WHEN** the user triggers logout while on `/constituency`
- **THEN** `pending_return_route` SHALL be set to `/constituency` in SharedPreferences before sign-out

#### Scenario: Logout from panchayat screen
- **WHEN** the user triggers logout while on `/panchayat`
- **THEN** `pending_return_route` SHALL be set to `/panchayat` in SharedPreferences before sign-out

#### Scenario: Logout from ward screen
- **WHEN** the user triggers logout while on `/ward`
- **THEN** `pending_return_route` SHALL be set to `/ward` in SharedPreferences before sign-out

#### Scenario: Logout from profile-setup screen
- **WHEN** the user triggers logout while on `/profile-setup`
- **THEN** `pending_return_route` SHALL be set to `/profile-setup` in SharedPreferences before sign-out

### Requirement: App resumes to saved return route after re-login
After re-login, if a `pending_return_route` exists in SharedPreferences and the user is not fully onboarded, the system SHALL navigate to that saved route and then clear the key.

#### Scenario: Return route consumed at splash after re-login
- **WHEN** the app launches, `bootstrapSession()` finds a valid but incomplete profile, and `pending_return_route` is set
- **THEN** `SplashController` SHALL navigate to `pending_return_route` and delete the key from SharedPreferences

#### Scenario: Return route ignored for fully onboarded user
- **WHEN** the app launches, `bootstrapSession()` finds a fully onboarded profile, and `pending_return_route` is set
- **THEN** the system SHALL navigate to `/home` and delete the stale `pending_return_route` key

#### Scenario: No return route set — normal resume
- **WHEN** the app launches and `pending_return_route` is not set
- **THEN** routing SHALL follow the standard `resolveOnboardingResumeRoute()` logic with no change in behavior

### Requirement: Logout from home/post-onboarding screens ignores return route
`AuthController.logout()` called from home or profile screens (fully onboarded context) SHALL NOT set `pending_return_route`. Post-logout navigation SHALL go to `/welcome` as today.

#### Scenario: Logout from home
- **WHEN** the user triggers logout from the home screen or profile screen
- **THEN** `pending_return_route` SHALL NOT be written to SharedPreferences
- **THEN** the user SHALL be navigated to `/welcome` after sign-out

