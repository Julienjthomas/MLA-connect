## REMOVED Requirements

### Requirement: App icon changes based on selected constituency
**Reason**: Feature adds native complexity (activity-alias, MethodChannel, lifecycle hooks) with minimal user value. Removed to simplify codebase.
**Migration**: No migration needed. App uses the single default launcher icon on all platforms.

#### Scenario: App always shows default icon
- **WHEN** user selects any constituency during onboarding or login
- **THEN** the launcher icon SHALL remain the default app icon unchanged

#### Scenario: No icon change on logout
- **WHEN** user logs out
- **THEN** the launcher icon SHALL remain the default app icon unchanged
