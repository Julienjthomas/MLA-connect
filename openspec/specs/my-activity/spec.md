## Purpose

Define the My Activity tab summary and submission history presentation.

## Requirements

### Requirement: Summary cards row
Above the tabs the view SHALL show summary cards for Reports, Resolved, Ideas, Appreciations counts derived from the user's submissions. No calendar icon SHALL be present on this screen.

#### Scenario: Counts reflect data
- **WHEN** the user has 3 reports and 1 idea
- **THEN** the corresponding cards show those numbers

#### Scenario: No calendar icon
- **WHEN** the My Activity screen renders
- **THEN** no calendar icon appears in the app bar, summary row, or anywhere on the screen
