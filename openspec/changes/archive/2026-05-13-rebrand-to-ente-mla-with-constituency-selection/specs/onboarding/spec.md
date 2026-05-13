## MODIFIED Requirements

### Requirement: Linear onboarding sequence
The onboarding flow SHALL follow this exact order: welcome → constituency → phone → OTP → panchayat → ward → profile setup → notifications → home.

#### Scenario: Forward navigation
- **WHEN** the user completes a step
- **THEN** the next step in the sequence opens via named route

#### Scenario: Constituency is first step after welcome
- **WHEN** an unauthenticated user taps "Continue" on the welcome screen
- **THEN** the app navigates to the constituency picker screen (before phone entry)

## ADDED Requirements

### Requirement: Pre-auth constituency selection
The constituency picker SHALL be shown to unauthenticated users as the first onboarding step. Selecting and confirming a constituency SHALL save the selection locally and navigate to the phone auth screen.

#### Scenario: First-time user sees constituency picker
- **WHEN** an unauthenticated user reaches the onboarding flow
- **THEN** the constituency picker is shown before the phone number entry screen

#### Scenario: Confirmation saves locally and proceeds to phone
- **WHEN** user selects a constituency and taps "Next"
- **THEN** selection is saved to SharedPreferences and the user navigates to the phone screen

#### Scenario: Post-auth constituency sync
- **WHEN** the user completes OTP verification
- **THEN** the locally saved constituency id is written to the user profile row in Supabase

### Requirement: Constituency picker skipped for returning users
If the user has already completed constituency selection (profile has a constituencyId), the constituency picker SHALL NOT be shown on re-launch or onboarding resume.

#### Scenario: Returning user with constituency in profile
- **WHEN** a logged-in user with `constituencyId` set relaunches the app
- **THEN** the constituency picker is bypassed and the app navigates directly to home or resume route

#### Scenario: Resume mid-onboarding with constituency set
- **WHEN** `resolveOnboardingResumeRoute()` is called and `profile.constituencyId` is not null
- **THEN** the returned route is panchayat, ward, profile setup, or notifications (never constituency)
