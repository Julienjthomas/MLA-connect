# mla-office-chat Specification

## Purpose
TBD - created by archiving change mla-citizen-multi-constituency. Update Purpose after archive.
## Requirements
### Requirement: Authenticated users can compose office messages
The app SHALL provide a Chat experience where a signed-in user can compose a text message to the MLA office for their active assembly constituency.

#### Scenario: Compose screen
- **WHEN** the user opens the Chat tab
- **THEN** a compose area is shown with a message body field and a send action

#### Scenario: Unauthenticated gate
- **WHEN** no Supabase session exists and the user navigates to Chat
- **THEN** the app blocks sending and prompts the user to sign in

### Requirement: Message categories
The compose flow SHALL default to category `'personal'` with no required user selection in the UI. The category picker is removed from the visible input area.

#### Scenario: Default category used on send
- **WHEN** the user sends a message without selecting a category
- **THEN** the message is submitted with category `'personal'`

### Requirement: Persist messages with constituency scope
Sending a message SHALL insert a row tied to `auth.uid()`, the message body, the selected category, and the user’s active `assembly_constituency_id`.

#### Scenario: Successful send
- **WHEN** the user sends a valid message
- **THEN** the client inserts the row and the message appears in the user’s history list for that constituency

#### Scenario: Send failure
- **WHEN** the insert fails (network or RLS)
- **THEN** the app shows an error and retains the draft text

### Requirement: Read own message history
The Chat tab SHALL list prior messages from newest to oldest for the current user (scoped to the active constituency or clearly labeled if mixed).

#### Scenario: History renders
- **WHEN** the user has previously sent messages
- **THEN** each item shows body preview or full text, category, and created timestamp

