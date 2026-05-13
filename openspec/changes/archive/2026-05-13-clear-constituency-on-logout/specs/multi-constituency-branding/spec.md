## MODIFIED Requirements

### Requirement: Constituency name persisted locally before auth
The selected constituency name and id SHALL be stored in SharedPreferences when the user selects a constituency on the pre-auth picker. Those keys SHALL be cleared when the Supabase session ends (explicit logout or `signedOut`) so logged-out surfaces do not reuse a prior user's selection.

#### Scenario: Prefs written on selection
- **WHEN** user taps a constituency in the pre-auth picker and proceeds
- **THEN** `constituency_id` and `constituency_name` keys are written to SharedPreferences

#### Scenario: Prefs available on next cold launch
- **WHEN** the app relaunches before the user completes auth and the user has not ended the session since saving the selection
- **THEN** the previously selected constituency is pre-selected in the picker

#### Scenario: Prefs cleared on session end
- **WHEN** the user logs out or the auth client emits `signedOut`
- **THEN** `constituency_id` and `constituency_name` are removed from SharedPreferences

### Requirement: Splash shows constituency subtitle dynamically
The splash screen SHALL display the selected constituency name as a subtitle line below "Ente MLA" only when a constituency is stored for the current anonymous onboarding attempt or resolved from the logged-in profile. After session end, it SHALL show the generic tagline until the user selects a constituency again.

#### Scenario: Constituency selected
- **WHEN** a constituency is stored in SharedPreferences for the current pre-auth attempt or the logged-in profile exposes a constituency name
- **THEN** splash shows "{constituency name} Constituency" as the subtitle

#### Scenario: No constituency selected
- **WHEN** no constituency is in SharedPreferences, no user profile constituency is available, or the session has ended and local constituency prefs were cleared
- **THEN** splash shows "Your MLA. Your Voice." as the subtitle
