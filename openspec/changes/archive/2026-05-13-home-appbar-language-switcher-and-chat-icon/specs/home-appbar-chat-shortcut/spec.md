## ADDED Requirements

### Requirement: Chat icon button in home app bar
The home screen app bar SHALL display a chat icon button as the rightmost action. Tapping SHALL navigate to the Chat screen via `Get.toNamed(Routes.chat)` as a pushed named route (not a shell tab switch).

#### Scenario: Navigate to chat from home app bar
- **WHEN** user taps the chat icon button in the home app bar
- **THEN** the Chat screen SHALL be pushed onto the navigation stack

#### Scenario: Back navigation from chat returns to home
- **WHEN** user is on the Chat screen accessed via the app bar button and presses back
- **THEN** user SHALL return to the home screen

#### Scenario: Chat screen loads messages on open
- **WHEN** user navigates to the Chat screen via the app bar button
- **THEN** ChatController SHALL load messages from Supabase as it does today
