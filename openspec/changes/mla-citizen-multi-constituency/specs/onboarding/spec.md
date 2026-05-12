## MODIFIED Requirements

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
- **THEN** the app resumes onboarding at the first incomplete step in the defined onboarding sequence

### Requirement: Linear onboarding sequence
The onboarding flow SHALL follow this exact order: welcome → phone → OTP → assembly constituency → local body → ward → profile setup → notifications → home.

#### Scenario: Forward navigation
- **WHEN** the user completes a step
- **THEN** the next step in the sequence opens via named route

### Requirement: Panchayat and ward are required before home
The user SHALL NOT reach the home shell without selecting an assembly constituency, a local body (panchayath), and a ward.

#### Scenario: Skip attempt
- **WHEN** ward is unselected on the ward step
- **THEN** the Continue button is disabled

## ADDED Requirements

### Requirement: Assembly constituency selection step
After OTP verification, the user SHALL select one assembly constituency from the seeded list (Balussery, Koduvalli, Perambra) before choosing a local body.

#### Scenario: Continue disabled without AC
- **WHEN** no assembly constituency is selected
- **THEN** the user cannot advance to local body selection

## REMOVED Requirements

### Requirement: Language selection persists for the session
**Reason**: Language selection is removed from onboarding; users set language from Profile settings after signup.
**Migration**: Remove the onboarding language route/step; persist language only when changed under Profile → Language (see `profile-settings` delta).
