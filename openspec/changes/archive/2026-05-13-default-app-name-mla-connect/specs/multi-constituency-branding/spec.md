## MODIFIED Requirements

### Requirement: App name is "MLA Connect" globally
The app display name SHALL be "MLA Connect" on all surfaces — splash screen, app bar titles, about section, onboarding success, and native OS app label.

#### Scenario: Splash renders correct name
- **WHEN** the splash screen renders
- **THEN** the primary heading displays "MLA Connect" (not "Ente MLA", "Super Balussery", or any constituency name)

#### Scenario: Native app label
- **WHEN** the app is installed on Android or iOS
- **THEN** the OS home screen shows "MLA Connect" as the app name
