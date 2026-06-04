## MODIFIED Requirements

### Requirement: Ward selection enforces cool-off after initial setup
After onboarding is complete, any subsequent ward change from the profile edit screen SHALL be subject to a 1-year cool-off period from the date of the last change. The onboarding flow itself (first-time setup) is exempt from this restriction.

#### Scenario: Ward change blocked during cool-off (post-onboarding)
- **WHEN** the citizen attempts to change their ward in the profile edit screen within 1 year of the last change
- **THEN** the ward selection is disabled and the UI displays "Ward can be changed after X days"

#### Scenario: First-time onboarding ward selection (exempt)
- **WHEN** the citizen selects a ward during initial onboarding (no prior ward stored)
- **THEN** the ward is saved without any cool-off check applied

#### Scenario: Ward change allowed after cool-off expires
- **WHEN** more than 1 year has passed since the citizen last changed their ward
- **THEN** the ward selection field in the profile edit screen is enabled and the citizen can select a new ward
