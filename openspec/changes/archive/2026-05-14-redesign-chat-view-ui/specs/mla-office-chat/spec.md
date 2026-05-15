## MODIFIED Requirements

### Requirement: Message categories
The compose flow SHALL default to category `'personal'` with no required user selection in the UI. The category picker is removed from the visible input area.

#### Scenario: Default category used on send
- **WHEN** the user sends a message without selecting a category
- **THEN** the message is submitted with category `'personal'`

## REMOVED Requirements

### Requirement: Category required before send
**Reason**: Category picker removed from ChatView input area in new design; default applied automatically.
**Migration**: `ChatController.category` defaults to `'personal'`. No user action needed. Category UI may be re-introduced via a bottom sheet in a future change.
