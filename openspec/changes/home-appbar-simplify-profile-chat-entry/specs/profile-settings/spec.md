## ADDED Requirements

### Requirement: Chat with MLA entry above notifications
The Profile tab SHALL display a **Chat with your MLA** entry between the user card and the Notifications section. Tapping it SHALL navigate to the Chat screen via `Get.toNamed(Routes.chat)`.

#### Scenario: Chat entry visible
- **WHEN** the Profile tab renders
- **THEN** a chat entry appears above the Notifications section label

#### Scenario: Open chat from profile
- **WHEN** the user taps the chat entry on Profile
- **THEN** the Chat screen is pushed onto the navigation stack

## MODIFIED Requirements

### Requirement: General settings tiles
The tab SHALL render tiles for: Language, Help & FAQ, Contact MLA Office, Privacy Policy. MLA chat SHALL NOT be duplicated as a separate General tile when the dedicated chat entry above Notifications is present.

#### Scenario: Tile presence
- **WHEN** the Profile tab renders
- **THEN** all four General tiles are visible in the General section
