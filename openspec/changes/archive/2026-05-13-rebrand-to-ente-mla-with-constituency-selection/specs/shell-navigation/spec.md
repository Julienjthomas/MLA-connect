## ADDED Requirements

### Requirement: Home header shows selected constituency name
The home shell header/MLA banner SHALL display the user's selected constituency name (from their profile) dynamically, not as a hardcoded string.

#### Scenario: Constituency name rendered from profile
- **WHEN** the home shell renders for a logged-in user
- **THEN** the MLA banner or home header subtitle shows the user's constituency name from their profile

#### Scenario: Fallback when constituency name unavailable
- **WHEN** the user's profile has no constituency name resolvable
- **THEN** the header subtitle is omitted or shows an empty state gracefully (no crash, no "Balussery")
