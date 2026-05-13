## MODIFIED Requirements

### Requirement: Logout clears session and routes to welcome
`logout()` SHALL call `auth.signOut()`, clear local constituency SharedPreferences, reset in-memory onboarding constituency state when `OnboardingController` is registered, null the cached user, and navigate to the welcome route.

#### Scenario: User taps Logout
- **WHEN** the user confirms the logout dialog on the profile tab
- **THEN** the session is signed out, local constituency prefs are cleared, onboarding constituency state is reset, and the welcome route is shown via `Get.offAllNamed`

### Requirement: Auth state subscription
The `AuthController` SHALL subscribe to `auth.onAuthStateChange` to refresh `user` on `signedIn` and clear local session context on `signedOut`.

#### Scenario: External sign-out
- **WHEN** the Supabase client emits `AuthChangeEvent.signedOut`
- **THEN** local constituency prefs are cleared, onboarding constituency state is reset when registered, and `user.value` becomes null
