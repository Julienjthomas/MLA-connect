## ADDED Requirements

### Requirement: Citizen can view their conversation threads
The chat screen SHALL display all conversation threads from `GET /citizens/:citizenId/conversations/threads`, ordered by most recent message.

#### Scenario: Threads exist
- **WHEN** the citizen opens the chat screen
- **THEN** a list of threads is shown with last message preview, timestamp, and unread count

#### Scenario: No threads
- **WHEN** the citizen has no conversation threads
- **THEN** an empty state is shown with a "Start a conversation" button

### Requirement: Citizen can create a new conversation thread
Tapping "Start a conversation" SHALL call `POST /citizens/:citizenId/conversations/threads` and navigate to the new thread.

#### Scenario: Thread created
- **WHEN** the citizen starts a new conversation
- **THEN** a new thread is created and the citizen is taken to the message view for that thread

### Requirement: Citizen can view messages in a thread
The thread detail screen SHALL display messages from `GET /citizens/:citizenId/conversations/threads/:threadId`, ordered chronologically.

#### Scenario: Messages load
- **WHEN** the citizen opens a thread
- **THEN** all messages are displayed with sender, content, and timestamp; own messages are right-aligned

#### Scenario: Empty thread
- **WHEN** the thread has no messages
- **THEN** a placeholder ("Send a message to start the conversation") is shown

### Requirement: Citizen can send a message in a thread
A text input at the bottom of the thread screen SHALL allow the citizen to send a message via `POST /citizens/:citizenId/conversations/threads/:threadId/messages`.

#### Scenario: Message sent
- **WHEN** the citizen types a message and taps send
- **THEN** the message appears in the thread immediately and the input is cleared

#### Scenario: Empty message
- **WHEN** the citizen taps send with an empty input
- **THEN** no API call is made

### Requirement: Closed threads are read-only
A thread with `status: "closed"` SHALL display a banner indicating it is closed and the message input SHALL be disabled.

#### Scenario: Closed thread viewed
- **WHEN** the citizen opens a thread with `status: "closed"`
- **THEN** a "This conversation is closed" banner is shown and the compose field is hidden
