## ADDED Requirements

### Requirement: Per-flavor environment files
The system SHALL maintain separate `.env.dev`, `.env.stg`, and `.env.prod` files with environment-specific configuration values.

#### Scenario: Each flavor has its own env file
- **WHEN** the project is checked out
- **THEN** `.env.dev`, `.env.stg`, `.env.prod` files exist at the project root with at minimum `BASE_URL` defined

### Requirement: Type-safe env access via envied
The system SHALL generate a type-safe Dart class from env files using `envied`, providing compile-time checked access to all environment variables.

#### Scenario: Access BASE_URL
- **WHEN** code accesses `Env.baseUrl`
- **THEN** it returns the `BASE_URL` value from the active flavor's env file as a `String` (non-nullable, compile-time verified)

#### Scenario: Missing env variable
- **WHEN** the env file is missing a variable referenced in the `Env` class
- **THEN** `build_runner` fails with a compile error identifying the missing variable

### Requirement: Env files excluded from version control
The system SHALL add `.env.*` pattern to `.gitignore` to prevent secrets from being committed.

#### Scenario: Git ignores env files
- **WHEN** a developer runs `git status`
- **THEN** `.env.dev`, `.env.stg`, `.env.prod` do not appear as untracked files

### Requirement: Env example file committed
The system SHALL include a `.env.example` file in version control showing required keys without values.

#### Scenario: New developer setup
- **WHEN** a developer clones the repo
- **THEN** `.env.example` lists all required keys (e.g. `BASE_URL=`, `SUPABASE_URL=`, `SUPABASE_ANON_KEY=`) as a reference for creating their own env files
