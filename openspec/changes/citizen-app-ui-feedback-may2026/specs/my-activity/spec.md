## MODIFIED Requirements

### Requirement: Summary cards row
Above the tabs the view SHALL show exactly four summary category icons with counts: Reports, Ideas, Improvements, and Appreciations, derived from the user's submissions. No calendar icon SHALL be present on this screen.

#### Scenario: Counts reflect data
- **WHEN** the user has 3 reports and 1 idea
- **THEN** the Reports card shows 3 and the Ideas card shows 1

#### Scenario: Four categories only
- **WHEN** the My Activity screen renders
- **THEN** exactly four summary category icons are shown in the summary row

#### Scenario: No calendar icon
- **WHEN** the My Activity screen renders
- **THEN** no calendar icon appears in the app bar, summary row, or anywhere on the screen

## ADDED Requirements

### Requirement: Saved tab content explanation
The Saved tab SHALL explain which content types users can save (for example Updates posts and publicly shared ideas) in its empty state and SHALL NOT expose an add-submission FAB.

#### Scenario: Saved empty state copy
- **WHEN** the user opens the Saved tab with no saved items
- **THEN** the empty state message describes what can be saved in this section

#### Scenario: No saved-tab add FAB
- **WHEN** the Saved tab is active
- **THEN** no floating action button for creating a new submission is shown

### Requirement: Report detail single title
Opening a report from My Activity SHALL show the submission title once in the detail body. The app bar SHALL use a generic report detail title and SHALL NOT duplicate the submission title in the app bar.

#### Scenario: Open report from list
- **WHEN** the user opens a report from the Reports tab
- **THEN** the submission title appears once in the detail content and not twice in the app bar and body

### Requirement: Report detail omits status timeline
The report detail view SHALL NOT render a status timeline section in this release.

#### Scenario: No timeline block
- **WHEN** the report detail view renders
- **THEN** no Status Timeline heading or timeline widget is shown
