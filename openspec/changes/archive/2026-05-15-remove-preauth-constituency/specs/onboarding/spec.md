## MODIFIED Requirements

### Requirement: Linear onboarding sequence
The onboarding flow SHALL follow this exact order: welcome → phone → OTP → constituency → panchayat → ward → profile setup → notifications → home.

#### Scenario: Forward navigation
- **WHEN** the user completes a step
- **THEN** the next step in the sequence opens via named route

#### Scenario: Phone is first step after welcome
- **WHEN** an unauthenticated user taps "Get Started" on the welcome screen
- **THEN** the app navigates to the phone number entry screen (constituency picker is NOT shown before login)

## REMOVED Requirements

### Requirement: Pre-auth constituency selection
**Reason**: Constituency selection before login caused users to see the picker twice. Post-auth routing via `resolveOnboardingResumeRoute()` already handles new users correctly.
**Migration**: Constituency selection now happens exclusively post-OTP, as the first step after authentication completes for users without a `constituencyId` on their profile.
