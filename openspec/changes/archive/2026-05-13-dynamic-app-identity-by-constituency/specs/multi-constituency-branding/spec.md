## MODIFIED Requirements

### Requirement: App name is "Ente MLA" globally
The app display name SHALL be "Ente MLA" on all in-app surfaces — splash screen, app bar titles, about section, onboarding success, and `GetMaterialApp.title`. The native OS home screen label SHALL remain "Ente MLA" (runtime name change is not supported). Constituency identity on the home screen is expressed via the launcher icon, not the app name.

#### Scenario: Splash renders correct name
- **WHEN** the splash screen renders
- **THEN** the primary heading displays "Ente MLA" (not "Super Balussery" or any constituency name)

#### Scenario: Native app label
- **WHEN** the app is installed on Android or iOS
- **THEN** the OS home screen shows "Ente MLA" as the app name regardless of active constituency
