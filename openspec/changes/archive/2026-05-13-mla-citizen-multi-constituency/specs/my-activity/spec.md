## ADDED Requirements

### Requirement: Office messages appear in My Activity
The My Activity experience SHALL surface the citizen’s messages to the MLA office (category, preview text, timestamp) alongside existing submission summaries, or SHALL provide an obvious control that navigates to the Chat/history view filtered to the current user.

#### Scenario: Message row visible
- **WHEN** the user has sent at least one office message
- **THEN** My Activity shows an entry or summary representing that message without requiring a cold restart

#### Scenario: Empty messages
- **WHEN** the user has never sent a message
- **THEN** My Activity does not show a broken placeholder for messages (section may be hidden)
