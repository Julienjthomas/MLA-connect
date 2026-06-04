## ADDED Requirements

### Requirement: App fetches remote config at startup
The app SHALL call `GET /app-config` before rendering any screen. The response SHALL be stored in the `AppConfig` singleton and used for feature flags and runtime configuration throughout the session.

#### Scenario: Config fetch succeeds
- **WHEN** the app launches and the network is available
- **THEN** the config response is parsed and stored in `AppConfig` before `runApp` completes

#### Scenario: Config fetch fails
- **WHEN** the app launches and the config endpoint is unreachable or returns an error
- **THEN** the app falls back to hardcoded defaults and launches normally without blocking the user

### Requirement: Feature flags from app-config gate UI elements
The app SHALL read feature flags from the fetched config to show or hide features (e.g., leaderboard, conversations) without a code release.

#### Scenario: Feature flag disabled
- **WHEN** a feature flag (e.g., `leaderboard_enabled`) is `false` in the config
- **THEN** the corresponding UI entry point (tab, menu item, button) is hidden

#### Scenario: Feature flag enabled
- **WHEN** a feature flag is `true` or absent (default enabled)
- **THEN** the corresponding UI entry point is visible and accessible
