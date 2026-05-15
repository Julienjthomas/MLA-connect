# chat-view-redesign Specification

## Purpose
Defines the visual and interaction requirements for the redesigned ChatView — empty state illustration, floating pill input bar, circular send FAB, and AppBar actions.

## Requirements

### Requirement: Empty state illustration
When no messages exist, ChatView SHALL display a centered chat-bubble illustration, a bold "Start a conversation" headline, and a subtitle "Send a message to the MLA office.\nWe'll get back to you soon." on a lavender background (`AppColors.surfaceVariant`).

#### Scenario: Empty state renders
- **WHEN** the authenticated user has zero messages and loading completes
- **THEN** the screen shows the illustration widget, headline, and subtitle centered vertically in the available space

#### Scenario: Empty state hidden when messages exist
- **WHEN** the user has one or more messages
- **THEN** the illustration and empty-state text are NOT shown; the message list renders instead

### Requirement: Floating pill input bar
The bottom input area SHALL be a rounded-pill container (white background, soft shadow, `borderRadius: 30`) containing a single-line text field with placeholder "Type your message…" and a paperclip attachment icon.

#### Scenario: Input bar always visible
- **WHEN** the authenticated user views the Chat screen (with or without messages)
- **THEN** the pill input bar is anchored at the bottom above safe area insets

#### Scenario: Placeholder text
- **WHEN** the input field is empty
- **THEN** placeholder "Type your message…" is shown in hint style

### Requirement: Circular send FAB
A solid-purple circular send button (using `AppColors.primary`) with a paper-plane icon SHALL appear to the right of the pill input bar, outside the pill container.

#### Scenario: Send taps controller
- **WHEN** the user taps the send FAB with non-empty text
- **THEN** `controller.send()` is invoked and the input clears on success

#### Scenario: Send disabled while sending
- **WHEN** `controller.sending.value` is true
- **THEN** the send FAB is visually disabled (reduced opacity or `onPressed: null`)

### Requirement: AppBar info action
The AppBar SHALL display the default back arrow on the left and an outlined info icon (ⓘ) on the right as an `IconButton`.

#### Scenario: Info icon present
- **WHEN** ChatView is open
- **THEN** an info icon button is visible in the AppBar trailing position
