## ADDED Requirements

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
