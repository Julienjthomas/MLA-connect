## ADDED Requirements

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
The onboarding flow SHALL follow this exact order: welcome → language → phone → OTP → panchayat → ward → profile setup → notifications → home.

#### Scenario: Forward navigation
- **WHEN** the user completes a step
- **THEN** the next step in the sequence opens via named route

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
