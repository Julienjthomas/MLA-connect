## REMOVED Requirements

### Requirement: Chat icon button in home app bar
**Reason**: MLA chat is entered from Profile and the shell Chat tab; the home app bar stays minimal.
**Migration**: Open Chat from Profile → Chat with your MLA or the Chat tab.

## ADDED Requirements

### Requirement: Home app bar excludes chat shortcut
The home screen app bar SHALL NOT display a chat icon action.

#### Scenario: Home app bar renders
- **WHEN** the home screen renders
- **THEN** no chat icon button appears in the home app bar
