## ADDED Requirements

### Requirement: Language is configured from Profile settings
The Profile tab Language tile SHALL open UI language selection. Saving a language choice SHALL persist to `user_profiles.language` and update the app locale immediately.

#### Scenario: Change language from profile
- **WHEN** the user selects a language in Profile and saves
- **THEN** `user_profiles.language` is updated and `GetMaterialApp` locale reflects the choice

#### Scenario: Onboarding does not require language
- **WHEN** a new user completes onboarding
- **THEN** they are never routed through a dedicated onboarding language screen

### Requirement: Constituency context visible on profile card
The profile header card SHALL show the user’s ward and local body together with the assembly constituency name (or an equivalent clear label).

#### Scenario: Location line
- **WHEN** the Profile tab renders for a completed profile
- **THEN** the location line includes assembly constituency, local body, and ward labels derived from stored profile fields
