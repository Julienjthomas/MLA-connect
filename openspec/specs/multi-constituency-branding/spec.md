## ADDED Requirements

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
- **THEN** the OS home screen shows "MLA Connect" as the app name regardless of active constituency (constituency identity is expressed via the launcher icon, not the app name)

### Requirement: Splash shows constituency subtitle dynamically
The splash screen SHALL display the selected constituency name as a subtitle line only when a constituency is resolved from the logged-in profile. Without an active session, it SHALL show the generic tagline.

#### Scenario: Constituency resolved from profile
- **WHEN** an active session exists and the logged-in profile exposes a constituency name
- **THEN** splash shows "{constituency name} Constituency" as the subtitle

#### Scenario: No session or no constituency
- **WHEN** no active session exists, or the profile has no constituency
- **THEN** splash shows "Your MLA. Your Voice." as the subtitle

### Requirement: Hardcoded "Balussery" strings removed
No visible UI string SHALL contain the literal text "Balussery" or "Super Balussery". All such references SHALL be replaced with either "Ente MLA" (app name) or the dynamically resolved constituency name.

#### Scenario: Strings audit
- **WHEN** the app renders any screen
- **THEN** no screen displays the literal text "Balussery" or "Super Balussery"
