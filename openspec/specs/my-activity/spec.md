## Purpose

Define the My Activity tab summary and submission history presentation.
## Requirements
### Requirement: Summary cards row
Above the tabs the view SHALL show summary cards for Reports, Resolved, Ideas, Improvements, and Appreciations counts derived from the user's submissions. No calendar icon SHALL be present on this screen.

#### Scenario: Counts reflect data
- **WHEN** the user has 3 reports, 1 idea, and 2 improvement suggestions
- **THEN** the corresponding cards show those numbers

#### Scenario: No calendar icon
- **WHEN** the My Activity screen renders
- **THEN** no calendar icon appears in the app bar, summary row, or anywhere on the screen

### Requirement: Submission tab floating add action
For each My Activity tab except Saved, the screen SHALL show a floating extended action button while that tab is selected. The button SHALL navigate to the submission flow for that tab's content type.

#### Scenario: Reports tab FAB
- **WHEN** the Reports tab is selected
- **THEN** a floating extended action button is visible
- **THEN** tapping it navigates to the report-problem flow

#### Scenario: Ideas tab FAB
- **WHEN** the Ideas tab is selected
- **THEN** a floating extended action button is visible
- **THEN** tapping it navigates to the share-idea flow

#### Scenario: Improvements tab FAB
- **WHEN** the Improvements tab is selected
- **THEN** a floating extended action button is visible
- **THEN** tapping it navigates to the suggest-improvement flow

#### Scenario: Appreciations tab FAB
- **WHEN** the Appreciations tab is selected
- **THEN** a floating extended action button is visible
- **THEN** tapping it navigates to the appreciation flow

#### Scenario: No FAB on Saved
- **WHEN** the Saved tab is selected
- **THEN** no floating action button is shown for adding submissions

#### Scenario: FAB with existing items
- **WHEN** the active submission tab has one or more listed items
- **THEN** the floating add action remains available without requiring an empty state

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

