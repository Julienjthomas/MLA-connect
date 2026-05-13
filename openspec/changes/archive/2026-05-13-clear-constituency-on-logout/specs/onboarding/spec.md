## ADDED Requirements

### Requirement: Logged-out welcome uses neutral branding
When no Supabase session is active, the welcome screen SHALL NOT display a constituency name from a prior session. It SHALL show generic Ente MLA branding until the user selects a constituency again in the current pre-auth flow.

#### Scenario: Welcome after logout
- **WHEN** the user completes logout and lands on the welcome screen
- **THEN** the welcome heading shows Ente MLA (or equivalent generic app name), not the previous user's constituency name

#### Scenario: Cold launch without session and without local constituency
- **WHEN** the app opens with no session and no constituency keys in SharedPreferences
- **THEN** the welcome screen shows generic Ente MLA branding

### Requirement: Pre-auth picker does not restore prior session constituency
After session end, the constituency picker SHALL NOT pre-select a constituency from SharedPreferences until the user saves a new selection in the current pre-auth flow.

#### Scenario: Constituency picker after logout
- **WHEN** a logged-out user opens the constituency picker immediately after logout
- **THEN** no constituency row is pre-selected from the previous session
