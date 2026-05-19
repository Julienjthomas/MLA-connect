## ADDED Requirements

### Requirement: Contact MLA Office screen exposes contact channels
The Contact MLA Office screen SHALL display the MLA office's contact channels (at minimum phone, email, address) sourced from the MLA record, with each channel actionable.

#### Scenario: User taps phone
- **WHEN** the user taps the phone entry
- **THEN** the device SHALL open the dialer prefilled with the office number via a `tel:` deep link

#### Scenario: User taps email
- **WHEN** the user taps the email entry
- **THEN** the device SHALL open the mail composer addressed to the office email via a `mailto:` deep link

#### Scenario: User taps address
- **WHEN** the user taps the address entry
- **THEN** the device SHALL open a maps app with the address as the query

### Requirement: Missing contact channels degrade gracefully
If a contact channel is missing on the MLA record, that entry SHALL be hidden rather than shown as empty.

#### Scenario: No email available
- **WHEN** the MLA record has no email
- **THEN** the email entry SHALL not appear on the Contact MLA Office screen
