## MODIFIED Requirements

### Requirement: Pre-auth constituency selection is transient
The constituency selected in the pre-auth picker SHALL be held in memory only (not written to SharedPreferences) until the user successfully authenticates. It SHALL NOT survive an app kill during pre-auth onboarding.

#### Scenario: Kill before login clears selection
- **WHEN** the user selects a constituency, kills the app before OTP verification, and cold-launches
- **THEN** no constituency is pre-selected and the splash shows "MLA Connect" as the primary title

#### Scenario: In-session selection still available
- **WHEN** the user selects a constituency and proceeds to phone/OTP screens in the same app session (without killing)
- **THEN** the selected constituency is available in memory for the profile save step

#### Scenario: Post-login constituency persisted
- **WHEN** the user successfully verifies OTP and the profile is written to the database
- **THEN** the constituency is stored on the user profile row and available on subsequent cold launches via the authenticated session
