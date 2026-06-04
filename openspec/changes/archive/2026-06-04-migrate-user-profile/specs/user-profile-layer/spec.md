## MODIFIED Requirements

### Requirement: Profile queries use REST API
`UserService` SHALL use REST API endpoints instead of Supabase table queries for all profile CRUD operations. The method signatures and `UserModel` interface SHALL remain unchanged.

#### Scenario: getProfile returns UserModel
- **WHEN** `UserService.getProfile(citizenId)` is called
- **THEN** calls `GET /citizens/:citizenId/profile` and maps response to `UserModel`

#### Scenario: createProfile upserts via REST
- **WHEN** `UserService.createProfile(data)` is called
- **THEN** calls `POST /citizens/:citizenId/basic-info/personal-info` with the profile payload

#### Scenario: updateProfile updates via REST
- **WHEN** `UserService.updateProfile(citizenId, data)` is called
- **THEN** calls `POST /citizens/:citizenId/profile/update` with the data map
