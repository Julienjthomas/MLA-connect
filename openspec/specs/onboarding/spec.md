## Purpose

Define onboarding navigation, persistence, and assembly-constituency selection gates.
## Requirements
### Requirement: Splash routes by auth + onboarding state
The splash screen SHALL determine the next route from session presence and onboarding completion.

#### Scenario: New user, no session
- **WHEN** the splash screen finishes its 2-second animation and the user has no Supabase session
- **THEN** the app navigates to the welcome screen with `Get.offAllNamed`

#### Scenario: Returning user, profile complete
- **WHEN** the splash finishes and a session exists and `hasCompletedOnboarding()` returns true
- **THEN** the app navigates to the home shell

#### Scenario: Returning user, partial onboarding
- **WHEN** a session exists but the user profile row is missing or incomplete
- **THEN** the app resumes onboarding at the panchayat selection step

### Requirement: Linear onboarding sequence
The onboarding flow SHALL follow this exact order: welcome → phone → OTP → constituency → panchayat → ward → profile setup → notifications → home.

#### Scenario: Forward navigation
- **WHEN** the user completes a step
- **THEN** the next step in the sequence opens via named route

#### Scenario: Phone is first step after welcome
- **WHEN** an unauthenticated user taps "Get Started" on the welcome screen
- **THEN** the app navigates to the phone number entry screen (constituency picker is NOT shown before login)

### Requirement: Language selection persists for the session
The user SHALL pick a UI language during onboarding and have it stored on their profile.

#### Scenario: Language saved
- **WHEN** the user selects a language and continues
- **THEN** the choice is persisted to `user_profiles.language` on profile-setup submission

### Requirement: Panchayat and ward are required before home
The user SHALL NOT reach the home shell without selecting both a panchayat and a ward.

#### Scenario: Skip attempt
- **WHEN** ward is unselected on the ward step
- **THEN** the Continue button is disabled

### Requirement: Constituency picker skipped for returning users
If the user has already completed constituency selection (profile has a constituencyId), the constituency picker SHALL NOT be shown on re-launch or onboarding resume.

#### Scenario: Returning user with constituency in profile
- **WHEN** a logged-in user with `constituencyId` set relaunches the app
- **THEN** the constituency picker is bypassed and the app navigates directly to home or resume route

#### Scenario: Resume mid-onboarding with constituency set
- **WHEN** `resolveOnboardingResumeRoute()` is called and `profile.constituencyId` is not null
- **THEN** the returned route is panchayat, ward, profile setup, or notifications (never constituency)

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

