## ADDED Requirements

### Requirement: Service uses REST API
The system SHALL use the REST API retrofit client instead of Supabase for all data operations in this module.

#### Scenario: Data fetched via REST
- **WHEN** any service method is called
- **THEN** it calls the corresponding REST endpoint via retrofit client

#### Scenario: No Supabase imports
- **WHEN** the migrated service file is inspected
- **THEN** it contains no `supabase_flutter` imports
