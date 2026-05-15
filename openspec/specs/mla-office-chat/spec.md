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

### Requirement: Chat screen shell matches approved snapshot
The Chat screen SHALL present a white app bar titled **Chat with MLA office** with a back affordance, a lavender-tinted message history region above a white composer block, and no upward shadow separating the composer from the history area.

#### Scenario: Signed-in chat shell renders
- **WHEN** a signed-in user opens the Chat screen
- **THEN** the app bar is white with centered title **Chat with MLA office**
- **AND** the message history area uses a light lavender/off-white background distinct from the white composer
- **AND** the composer block does not display an elevation or drop shadow above the form

### Requirement: Chat empty state matches approved snapshot
When the user has no prior messages for the active constituency, the Chat screen SHALL show centered secondary text in the history region reading **No messages yet.** on the first line and **Use the form below to send your first message.** on the second line.

#### Scenario: Empty history copy
- **WHEN** a signed-in user has no messages in history
- **THEN** the history region shows the two-line empty-state copy centered horizontally and vertically

### Requirement: Category selector matches approved snapshot
The compose area SHALL label the control **Category** and SHALL offer selectable pills for **Personal message**, **Request**, **Invitation**, and **Other**. The default selection SHALL be **Personal message**. Selected pills SHALL use a light purple background, purple label text, and a leading checkmark icon. Unselected pills SHALL use a white background, light gray border, and dark gray label text without a checkmark.

#### Scenario: Default category presentation
- **WHEN** the signed-in user opens the Chat compose area
- **THEN** **Personal message** appears selected with checkmark, light purple fill, and purple label styling
- **AND** **Request**, **Invitation**, and **Other** appear unselected with white fill and gray border styling

#### Scenario: Category selection updates styling
- **WHEN** the user selects a different category pill
- **THEN** that pill becomes the only selected pill with checkmark and selected styling
- **AND** the previously selected pill returns to unselected styling

### Requirement: Message field matches approved snapshot
The compose area SHALL provide a multi-line message field with placeholder **Write your message...**, light gray fill, rounded corners, and no visible outline border.

#### Scenario: Message field presentation
- **WHEN** the signed-in user views the Chat compose area
- **THEN** the message field shows placeholder **Write your message...**
- **AND** the field background is light gray with rounded corners and no outline border

### Requirement: Send action matches approved snapshot
The compose area SHALL provide a full-width **Send** button below the message field using solid primary purple fill, white bold label text, and a pill-shaped rounded shape spanning the composer content width.

#### Scenario: Send button presentation
- **WHEN** the signed-in user views the Chat compose area
- **THEN** a full-width **Send** button appears below the message field with primary purple background and pill-shaped corners

