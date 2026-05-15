## ADDED Requirements

### Requirement: Onboarding selections persisted incrementally to local storage
The system SHALL write each completed onboarding selection to SharedPreferences immediately when the user taps "Continue" on that screen, before navigating to the next step.

#### Scenario: Constituency selected
- **WHEN** the user selects a constituency and taps Continue on the constituency screen
- **THEN** `constituency_id` and `constituency_name` SHALL be written to SharedPreferences before navigation

#### Scenario: Local body selected
- **WHEN** the user selects a local body (panchayat) and taps Continue on the panchayat screen
- **THEN** `local_body_id` and `local_body_name` SHALL be written to SharedPreferences before navigation

#### Scenario: Ward selected
- **WHEN** the user selects a ward and taps Continue on the ward screen
- **THEN** `ward_id` and `ward_name` SHALL be written to SharedPreferences before navigation

### Requirement: Resume route derived from persisted prefs
The system SHALL calculate the onboarding resume route by reading SharedPreferences keys in order (ward → local_body → constituency), returning the first incomplete step. The user model fields SHALL be used only as a fallback when prefs are absent.

#### Scenario: All prefs present — user is fully onboarded
- **WHEN** SharedPreferences contains `constituency_id`, `local_body_id`, `ward_id`, and `AuthController.user.name` is non-empty
- **THEN** resume route SHALL be `/home`

#### Scenario: Ward pref missing
- **WHEN** `constituency_id` and `local_body_id` exist in prefs but `ward_id` does not
- **THEN** resume route SHALL be `/ward`

#### Scenario: Local body pref missing
- **WHEN** `constituency_id` exists in prefs but `local_body_id` does not
- **THEN** resume route SHALL be `/panchayat`

#### Scenario: No prefs at all
- **WHEN** no onboarding prefs exist in SharedPreferences
- **THEN** resume route SHALL be `/constituency`

#### Scenario: Name missing (profile setup incomplete)
- **WHEN** `constituency_id`, `local_body_id`, and `ward_id` all exist in prefs but `AuthController.user.name` is empty or "Citizen"
- **THEN** resume route SHALL be `/profile-setup`

### Requirement: Local storage cleared on logout
The system SHALL clear all onboarding SharedPreferences keys (constituency_id, constituency_name, local_body_id, local_body_name, ward_id, ward_name) when the user logs out, so a subsequent user on the same device starts fresh.

#### Scenario: Logout clears all geo prefs
- **WHEN** `AuthController.logout()` is called
- **THEN** all onboarding-related SharedPreferences keys SHALL be deleted before the Supabase sign-out completes
