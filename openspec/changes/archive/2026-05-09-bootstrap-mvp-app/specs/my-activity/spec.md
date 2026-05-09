## ADDED Requirements

### Requirement: Four-tab activity view
The My Activity tab SHALL show four sub-tabs in order: Reports, Ideas, Appreciations, Saved.

#### Scenario: Tab order
- **WHEN** the My Activity tab opens
- **THEN** the `TabBar` shows the four labels from `ActivityTab`

### Requirement: Summary cards row
Above the tabs the view SHALL show summary cards for Reports, Resolved, Ideas, Appreciations counts derived from the user's submissions.

#### Scenario: Counts reflect data
- **WHEN** the user has 3 reports and 1 idea
- **THEN** the corresponding cards show those numbers

### Requirement: Each tab renders ActivityCard list or EmptyState
Each tab SHALL render an `ActivityCard` per item or an `EmptyState` widget when empty.

#### Scenario: Empty Saved tab
- **WHEN** the user has no saved items
- **THEN** the Saved tab shows an `EmptyState`

### Requirement: Report card opens detail
Tapping a report `ActivityCard` SHALL push `Routes.reportDetail` with the report id.

#### Scenario: Tap report card
- **WHEN** the user taps a report card
- **THEN** the detail route opens with the id as argument
