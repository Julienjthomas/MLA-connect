## ADDED Requirements

### Requirement: Citizen can change the visibility of their own submission
On the detail screen of a citizen's own concern, idea, or appreciation, a visibility control SHALL allow changing between `public`, `private`, and `anonymous`.

#### Scenario: Visibility changed
- **WHEN** the citizen selects a different visibility option for their submission
- **THEN** the app calls the update endpoint with the new visibility value and the UI reflects the change

#### Scenario: Visibility options displayed
- **WHEN** the citizen taps the visibility control
- **THEN** a bottom sheet or dialog shows three options: Public, Private, Anonymous with current value pre-selected

### Requirement: Citizen can delete their own submission with confirmation
A delete action SHALL be available on the detail screen of the citizen's own concern, idea, or appreciation. A confirmation dialog SHALL appear before calling the delete API.

#### Scenario: Delete initiated
- **WHEN** the citizen taps the delete button on their own submission
- **THEN** a confirmation dialog appears stating the deletion is permanent

#### Scenario: Deletion confirmed
- **WHEN** the citizen confirms deletion
- **THEN** the API call is made (`DELETE /citizens/:citizenId/<entity>/:entityId`), the user is navigated back to the list screen, and the item is removed from the list

#### Scenario: Deletion cancelled
- **WHEN** the citizen taps "Cancel" in the deletion dialog
- **THEN** the dialog closes and no API call is made

#### Scenario: Delete controls hidden for other citizens' submissions
- **WHEN** the citizen views a public submission from another citizen
- **THEN** no delete or visibility controls are shown
