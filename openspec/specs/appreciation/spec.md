## ADDED Requirements

### Requirement: Appreciation recipients limited to MLA and direct staff
The appreciation flow's recipient picker SHALL only allow selecting the MLA or a member of the MLA's direct staff. No other recipients (general public users, third parties, free-text entries) SHALL be selectable.

#### Scenario: Recipient list contents
- **WHEN** the user reaches the recipient step
- **THEN** the list SHALL contain the MLA as the first entry followed by direct staff members
- **THEN** no other users SHALL appear in the list

#### Scenario: No free-text recipient
- **WHEN** the user is on the recipient step
- **THEN** the UI SHALL NOT offer a free-text input to type an arbitrary recipient name
