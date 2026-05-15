## ADDED Requirements

### Requirement: Launcher icon reflects active constituency
The app launcher icon SHALL switch to a constituency-specific icon variant when a constituency is active (selected pre-auth or resolved from logged-in profile). It SHALL revert to the default neutral icon when no constituency is active.

#### Scenario: Constituency selected during onboarding
- **WHEN** user selects a constituency in the pre-auth onboarding picker
- **THEN** the launcher icon switches to the icon variant for that constituency within the current session

#### Scenario: Profile resolved on login
- **WHEN** the user logs in and their profile's constituency is resolved
- **THEN** the launcher icon switches to the icon variant matching their constituency

#### Scenario: No constituency active (logged out or pre-selection)
- **WHEN** no constituency is stored in SharedPreferences and no user profile constituency is available
- **THEN** the launcher icon shows the default neutral "Ente MLA" icon

#### Scenario: Logout clears icon
- **WHEN** the user logs out or the auth client emits `signedOut`
- **THEN** the launcher icon reverts to the default neutral icon

### Requirement: Icon switch is non-crashing on unsupported environments
The icon-switching mechanism SHALL fail gracefully (catch and log) if the platform does not support alternate icons (e.g., Android emulator, iOS Simulator, or older OS versions). The app SHALL remain fully functional with the default icon.

#### Scenario: Platform does not support alternate icons
- **WHEN** `AppIconService.setForConstituency(slug)` is called on a platform or OS version that does not support the feature
- **THEN** the call catches the exception, logs a warning, and does not crash the app

### Requirement: Unknown constituency slug falls back to default icon
If the constituency slug stored in prefs or profile does not match a known icon variant, the service SHALL apply the default icon rather than throwing.

#### Scenario: Unrecognized slug
- **WHEN** `AppIconService.setForConstituency(slug)` is called with a slug not in `ConstituencySeed.knownSlugs`
- **THEN** the default icon is applied and a warning is logged
