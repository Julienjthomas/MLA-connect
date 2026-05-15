## MODIFIED Requirements

### Requirement: App name is "MLA Connect" globally
The app display name SHALL be "MLA Connect" on all surfaces — splash screen, app bar titles, about section, onboarding success, and native OS app label.

#### Scenario: Cold launch without session shows generic name
- **WHEN** the app is cold-launched with no active Supabase session
- **THEN** the splash screen SHALL display "MLA Connect" as the primary title regardless of any previously selected constituency in the pre-auth picker

#### Scenario: Cold launch with active session shows constituency
- **WHEN** the app is cold-launched and an active session exists with a constituency on the user profile
- **THEN** the splash screen MAY display the constituency name

#### Scenario: Native app label
- **WHEN** the app is installed on Android or iOS
- **THEN** the OS home screen shows "MLA Connect" as the app name
