## ADDED Requirements

### Requirement: Hall of Excellence listing
The app SHALL provide a Hall of Excellence screen reachable from the home Hall of Excellence card and `Routes.achievementsListing`. The screen SHALL list achievement entries when data exists and SHALL show an empty state when none exist.

#### Scenario: Empty listing
- **WHEN** no achievements are available for the active constituency
- **THEN** the screen shows an empty state with title and message explaining achievements and recognitions

#### Scenario: Populated listing
- **WHEN** one or more achievements exist
- **THEN** each entry shows at minimum a display name and achievement label in a scrollable list

### Requirement: Add Achievement action
The Hall of Excellence screen SHALL expose an Add Achievement primary action. Tapping it SHALL open an add-achievement flow; the action SHALL NOT be a no-op.

#### Scenario: Tap Add Achievement
- **WHEN** the user taps Add Achievement on the listing screen
- **THEN** the add-achievement flow opens

#### Scenario: Successful add
- **WHEN** the user submits valid achievement details
- **THEN** the flow completes with success feedback and the listing reflects the new or pending entry

### Requirement: Add Achievement required fields
The add-achievement flow SHALL require at minimum achiever name, institution or context, and achievement title or description before submit.

#### Scenario: Submit blocked
- **WHEN** required fields are empty
- **THEN** submit is blocked with validation feedback
