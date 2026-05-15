## ADDED Requirements

### Requirement: MLA Hero Card displays full profile
The home view SHALL display a full MLA hero card replacing the compact banner. The card SHALL show the MLA photo (large, left side), MLA name, constituency name with "Your MLA" label above it, and three contact action buttons below: Contact Office, Message MLA, Meet MLA.

#### Scenario: Card renders with data
- **WHEN** the home view loads and MLA data is available
- **THEN** the card displays MLA photo, name, constituency, and all three action buttons

#### Scenario: Card renders with missing photo
- **WHEN** MLA photo URL is null or empty
- **THEN** a person icon placeholder is shown in the photo slot

### Requirement: MLA Hero Card contact actions
The card SHALL include three tappable action buttons in a row: Contact Office (phone icon), Message MLA (message icon), Meet MLA (calendar icon). Each button shows an icon above a label.

#### Scenario: Contact Office tapped
- **WHEN** user taps "Contact Office"
- **THEN** the device phone dialer opens with the MLA office phone number

#### Scenario: Message MLA tapped
- **WHEN** user taps "Message MLA"
- **THEN** navigation goes to the MLA office chat route

#### Scenario: Meet MLA tapped
- **WHEN** user taps "Meet MLA"
- **THEN** navigation goes to the MLA detail route
