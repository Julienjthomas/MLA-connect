## Purpose

Define profile tab identity, location, and settings entry points.
## Requirements
### Requirement: User card with avatar, name, phone, location
The Profile tab SHALL show a card at the top displaying the user's avatar (or initials fallback), name, phone, and ward + panchayat.

#### Scenario: No avatar URL
- **WHEN** `user.avatarUrl` is null or empty
- **THEN** the avatar circle shows two-letter initials derived from `user.name`

### Requirement: Notification preference switches
The tab SHALL expose four switches: Issue Updates, MLA Announcements, Emergency Alerts, Event Reminders.

#### Scenario: Toggle
- **WHEN** the user flips a switch
- **THEN** the corresponding `RxBool` on `ProfileController` updates

### Requirement: General settings tiles
The tab SHALL render tiles for: Language, Help & FAQ, Contact MLA Office, Privacy Policy. MLA chat SHALL NOT be duplicated as a separate General tile when the dedicated chat entry above Notifications is present.

#### Scenario: Tile presence
- **WHEN** the Profile tab renders
- **THEN** all four General tiles are visible in the General section

### Requirement: Logout requires confirmation
Tapping the Logout tile SHALL show a confirmation dialog with Cancel and Logout actions; only confirm calls `AuthController.logout()`.

#### Scenario: User cancels
- **WHEN** the user taps Cancel in the dialog
- **THEN** the dialog dismisses and no logout occurs

#### Scenario: User confirms
- **WHEN** the user taps Logout in the dialog
- **THEN** the dialog dismisses and `AuthController.logout()` is invoked, navigating to welcome

### Requirement: Chat with MLA entry above notifications
The Profile tab SHALL display a **Chat with your MLA** entry between the user card and the Notifications section. Tapping it SHALL navigate to the Chat screen via `Get.toNamed(Routes.chat)`.

#### Scenario: Chat entry visible
- **WHEN** the Profile tab renders
- **THEN** a chat entry appears above the Notifications section label

#### Scenario: Open chat from profile
- **WHEN** the user taps the chat entry on Profile
- **THEN** the Chat screen is pushed onto the navigation stack

