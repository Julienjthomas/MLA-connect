## ADDED Requirements

### Requirement: Profile fetch via REST
The system SHALL fetch citizen profile via `GET /citizens/:citizenId/profile` and map the response to `UserModel`.

#### Scenario: Profile fetched successfully
- **WHEN** `UserService.getProfile(citizenId)` is called
- **THEN** `GET /citizens/:citizenId/profile` is called and response mapped to `UserModel`

#### Scenario: Profile not found
- **WHEN** endpoint returns 404
- **THEN** `getProfile` returns null

### Requirement: Profile update via REST
The system SHALL update citizen profile via `POST /citizens/:citizenId/profile/update`.

#### Scenario: Profile updated
- **WHEN** `UserService.updateProfile(citizenId, data)` is called
- **THEN** `POST /citizens/:citizenId/profile/update` is called with data payload

### Requirement: Onboarding profile create via REST
The system SHALL create/upsert citizen profile via `POST /citizens/:citizenId/basic-info/personal-info`.

#### Scenario: Profile created during onboarding
- **WHEN** `UserService.createProfile(data)` is called
- **THEN** `POST /citizens/:citizenId/basic-info/personal-info` is called with name, phone, language, constituency, ward fields

### Requirement: Notification preferences via REST settings
The system SHALL save notification preferences via `PUT /citizens/:citizenId/settings`.

#### Scenario: Notification prefs saved
- **WHEN** `UserService.saveNotificationPrefs(citizenId, prefs)` is called
- **THEN** `PUT /citizens/:citizenId/settings` is called with preferences payload
