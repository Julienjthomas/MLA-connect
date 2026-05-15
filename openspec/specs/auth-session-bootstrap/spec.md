# auth-session-bootstrap Specification

## Purpose
TBD - created by archiving change fix-auth-onboarding-routing. Update Purpose after archive.
## Requirements
### Requirement: Profile loaded before routing at splash
The system SHALL fetch the authenticated user's full citizen profile from Supabase and populate `AuthController.user` before any routing decision is made at splash time. If the user has no active session, this step SHALL be skipped entirely.

#### Scenario: Authenticated user with complete profile
- **WHEN** the app launches and a valid Supabase session exists
- **THEN** `AuthController.bootstrapSession()` SHALL fetch the citizen profile and populate `AuthController.user` before `SplashController` navigates anywhere

#### Scenario: Authenticated user with no citizens row yet
- **WHEN** the app launches, a session exists, but no citizens DB row exists for the user
- **THEN** `bootstrapSession()` SHALL complete without error, `AuthController.user` SHALL be null or empty, and routing SHALL proceed to the onboarding resume route

#### Scenario: Unauthenticated user
- **WHEN** the app launches and no Supabase session exists
- **THEN** `bootstrapSession()` SHALL return immediately without making any network call, and routing SHALL proceed to `/welcome`

#### Scenario: Profile fetch fails (network error)
- **WHEN** the app launches, a session exists, but the Supabase profile fetch throws an error
- **THEN** `bootstrapSession()` SHALL catch the error, leave `AuthController.user` as null, and routing SHALL still proceed (to onboarding resume or welcome as applicable) — the app SHALL NOT crash or hang

### Requirement: Citizen data available to all screens
The system SHALL guarantee that any screen rendered after splash can safely read `AuthController.user` without triggering an additional async fetch of its own.

#### Scenario: Onboarding screen renders after bootstrap
- **WHEN** a user is routed to an onboarding screen (constituency, panchayat, ward, profile-setup)
- **THEN** `AuthController.user` SHALL already contain the latest fetched profile data (or be explicitly null if no profile exists)

