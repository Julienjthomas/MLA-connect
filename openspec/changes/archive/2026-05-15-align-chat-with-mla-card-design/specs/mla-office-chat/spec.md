## MODIFIED Requirements

### Requirement: Chat entry-point card visual design
The profile screen's chat entry card SHALL display a circular icon badge containing a capitol/parliament building icon (not a chat bubble), an "MLA Office Support" title, a "Message the constituency office directly." subtitle, and a labelled "Start Chat" outlined button as the trailing action — replacing the previous square icon and bare chevron.

#### Scenario: Card renders with new design
- **WHEN** the user views the profile screen
- **THEN** the chat entry card shows a circular primary-tinted container with `account_balance_rounded` icon, bold "MLA Office Support" title, gray subtitle, and an outlined "Start Chat" button on the right

#### Scenario: Start Chat button taps to chat
- **WHEN** the user taps the "Start Chat" button
- **THEN** the app navigates to the Chat screen (same destination as tapping the full card)

#### Scenario: Full card tap still navigates
- **WHEN** the user taps anywhere on the card (outside the button)
- **THEN** the app navigates to the Chat screen
