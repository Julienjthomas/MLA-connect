## MODIFIED Requirements

### Requirement: Geography data sourced from REST API
`UserService` geography methods SHALL call REST API endpoints instead of Supabase tables. Seed fallback behavior SHALL be preserved.

#### Scenario: getConstituencies uses REST
- **WHEN** `getConstituencies()` is called
- **THEN** calls `GET /constituencies` before falling back to seed data

#### Scenario: getLocalBodies uses REST
- **WHEN** `getLocalBodies(constituencyId: id)` is called
- **THEN** calls `GET /constituencies/:constituencyId/local-bodies` before falling back to seed

#### Scenario: getWards uses REST
- **WHEN** `getWards(localBodyId, constituencyId: id)` is called
- **THEN** calls `GET /constituencies/:constituencyId/local-bodies/:localBodyId/wards` before fallback
