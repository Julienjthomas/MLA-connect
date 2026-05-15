## ADDED Requirements

### Requirement: Community Impact section displays stats
The home view SHALL display a "Community Impact" section with tagline "Together we are creating real change" and three stat chips in a row: Issues Resolved (green check icon), Ideas Implemented (purple bulb icon), Appreciations Shared (orange heart icon). Values sourced from MlaStats.

#### Scenario: Section renders with data
- **WHEN** MLA data is loaded
- **THEN** Community Impact section shows all three stat chips with numeric values

#### Scenario: Section renders with zero values
- **WHEN** MLA stats are all zero
- **THEN** chips display "0" for each stat
