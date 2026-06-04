## ADDED Requirements

### Requirement: Constituencies from REST with seed fallback
The system SHALL fetch constituencies via `GET /constituencies` and fall back to seed data when REST returns empty or fails.

#### Scenario: REST returns constituencies
- **WHEN** `UserService.getConstituencies()` is called and REST returns ≥1 result
- **THEN** returns REST data as list of `ConstituencyModel`

#### Scenario: REST returns empty or fails
- **WHEN** `GET /constituencies` returns empty list or throws
- **THEN** returns seed constituencies from `ConstituencySeed`

### Requirement: Local bodies from REST with seed fallback
The system SHALL fetch local bodies via `GET /constituencies/:constituencyId/local-bodies` and fall back to seed data when REST returns empty or fails.

#### Scenario: REST returns local bodies
- **WHEN** `UserService.getLocalBodies(constituencyId: id)` is called and REST returns ≥1 result
- **THEN** returns REST data as list of `LocalBodyModel`

#### Scenario: REST returns empty or fails
- **WHEN** endpoint returns empty or throws
- **THEN** returns seed local bodies for the constituency

### Requirement: Wards from REST with seed fallback
The system SHALL fetch wards via `GET /constituencies/:constituencyId/local-bodies/:localBodyId/wards` and fall back to synthetic wards when REST returns empty or fails.

#### Scenario: REST returns wards
- **WHEN** `UserService.getWards(localBodyId, constituencyId: id)` is called and REST returns ≥1 result
- **THEN** returns REST data as list of `WardModel`

#### Scenario: Fallback wards generated
- **WHEN** endpoint returns empty or throws
- **THEN** returns synthetic wards using seed ward counts
