## ADDED Requirements

### Requirement: Improvements activity tab
The My Activity screen SHALL include an Improvements tab that lists the signed-in user's improvement submissions (`submissions` with `kind='suggestion'`) or an `EmptyState` when none exist.

#### Scenario: Improvements tab shows submissions
- **WHEN** the user has at least one improvement submission
- **THEN** the Improvements tab lists each item with suggestion summary and time ago

#### Scenario: Empty improvements tab
- **WHEN** the user has no improvement submissions
- **THEN** the Improvements tab shows an `EmptyState` with a shortcut to the suggest-improvement flow

### Requirement: Tab order includes improvements
The My Activity `TabBar` SHALL show tabs in order: Reports, Ideas, Improvements, Appreciations, Saved, using labels from `ActivityTab`.

#### Scenario: Tab order
- **WHEN** the My Activity tab opens
- **THEN** the `TabBar` shows the five labels from `ActivityTab` in that order

## MODIFIED Requirements

### Requirement: Summary cards row
Above the tabs the view SHALL show summary cards for Reports, Resolved, Ideas, Improvements, and Appreciations counts derived from the user's submissions. No calendar icon SHALL be present on this screen.

#### Scenario: Counts reflect data
- **WHEN** the user has 3 reports, 1 idea, and 2 improvement suggestions
- **THEN** the corresponding cards show those numbers

#### Scenario: No calendar icon
- **WHEN** the My Activity screen renders
- **THEN** no calendar icon appears in the app bar, summary row, or anywhere on the screen
