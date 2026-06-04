## ADDED Requirements

### Requirement: Citizen can request account deletion from profile settings
A "Delete Account" option SHALL be available in the profile settings screen.

#### Scenario: Delete Account option visible
- **WHEN** the citizen navigates to profile settings
- **THEN** a "Delete Account" option is displayed in a danger/destructive section

### Requirement: Account deletion requires explicit confirmation
Before calling the delete API, the app SHALL present a confirmation dialog explaining the consequences.

#### Scenario: Confirmation dialog shown
- **WHEN** the citizen taps "Delete Account"
- **THEN** a dialog appears stating that the action is irreversible and all data will be deleted, with a "Cancel" and "Delete My Account" button

#### Scenario: Citizen cancels deletion
- **WHEN** the citizen taps "Cancel" in the confirmation dialog
- **THEN** the dialog closes and no API call is made

### Requirement: Confirmed deletion calls the delete account API and logs out
After confirmation, the app SHALL call `DELETE /citizens/:citizenId/account`, clear all local tokens and session data, and navigate the user to the welcome/login screen.

#### Scenario: Deletion succeeds
- **WHEN** the citizen confirms deletion and the API returns success
- **THEN** all tokens are cleared, all local data is wiped, and the user is routed to the welcome screen

#### Scenario: Deletion API fails
- **WHEN** the delete API returns an error
- **THEN** the user sees an error message and remains on the profile settings screen; no session data is cleared
