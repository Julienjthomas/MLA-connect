## MODIFIED Requirements

### Requirement: Profile loaded before routing at splash
The system SHALL check JWT presence in secure storage (instead of Supabase session) to determine if a user is authenticated at splash time, then fetch the citizen profile before routing.

#### Scenario: Authenticated user — JWT present
- **WHEN** the app launches and `auth_token` exists in secure storage
- **THEN** `bootstrapSession()` SHALL fetch the citizen profile using the stored citizenId and populate `AuthController.user` before routing

#### Scenario: Unauthenticated user — no JWT
- **WHEN** the app launches and `auth_token` is absent from secure storage
- **THEN** `bootstrapSession()` SHALL return immediately without any network call, and routing SHALL proceed to `/welcome`

#### Scenario: Profile fetch fails
- **WHEN** the app launches, JWT exists, but profile fetch throws
- **THEN** `bootstrapSession()` SHALL catch the error, leave `AuthController.user` as null, and routing SHALL still proceed
