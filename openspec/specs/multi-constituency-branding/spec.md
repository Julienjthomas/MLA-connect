## ADDED Requirements

### Requirement: App name is "Ente MLA" globally
The app display name SHALL be "Ente MLA" on all surfaces — splash screen, app bar titles, about section, onboarding success, and native OS app label.

#### Scenario: Splash renders correct name
- **WHEN** the splash screen renders
- **THEN** the primary heading displays "Ente MLA" (not "Super Balussery" or any constituency name)

#### Scenario: Native app label
- **WHEN** the app is installed on Android or iOS
- **THEN** the OS home screen shows "Ente MLA" as the app name

### Requirement: Constituency name persisted locally before auth
The selected constituency name and id SHALL be stored in SharedPreferences immediately when the user selects a constituency on the pre-auth picker, so it is available across app restarts even before a user profile exists.

#### Scenario: Prefs written on selection
- **WHEN** user taps a constituency in the pre-auth picker and proceeds
- **THEN** `constituency_id` and `constituency_name` keys are written to SharedPreferences

#### Scenario: Prefs available on next cold launch
- **WHEN** the app relaunches before the user completes auth
- **THEN** the previously selected constituency is pre-selected in the picker

### Requirement: Splash shows constituency subtitle dynamically
The splash screen SHALL display the selected constituency name as a subtitle line below "Ente MLA". If no constituency has been selected yet, it SHALL show a generic tagline.

#### Scenario: Constituency selected
- **WHEN** a constituency is stored in SharedPreferences
- **THEN** splash shows "{constituency name} Constituency" as the subtitle

#### Scenario: No constituency selected
- **WHEN** no constituency is in SharedPreferences and no user profile exists
- **THEN** splash shows "Your MLA. Your Voice." as the subtitle

### Requirement: Hardcoded "Balussery" strings removed
No visible UI string SHALL contain the literal text "Balussery" or "Super Balussery". All such references SHALL be replaced with either "Ente MLA" (app name) or the dynamically resolved constituency name.

#### Scenario: Strings audit
- **WHEN** the app renders any screen
- **THEN** no screen displays the literal text "Balussery" or "Super Balussery"
