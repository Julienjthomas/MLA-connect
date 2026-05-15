## REMOVED Requirements

### Requirement: Language toggle button in home app bar
**Reason**: Language selection belongs on the Profile tab; the home app bar is reserved for constituency identity and notifications.
**Migration**: Use Profile → General → Language to change locale.

## ADDED Requirements

### Requirement: Home app bar excludes language control
The home screen app bar SHALL NOT display a language toggle or locale switch control.

#### Scenario: Home app bar renders
- **WHEN** the home screen renders
- **THEN** no language toggle button appears in the home app bar
