## MODIFIED Requirements

### Requirement: AppConfig uses envied-generated values
`AppConfig.init()` SHALL read environment values from the envied-generated `Env` class instead of hardcoded strings. Supabase URL/key and the new `BASE_URL` are all sourced from env files.

#### Scenario: AppConfig initialized with env values
- **WHEN** `AppConfig.init(AppFlavor.dev)` is called
- **THEN** `AppConfig.baseUrl` returns the `BASE_URL` from `.env.dev` via `Env.baseUrl`
- **AND** `AppConfig.supabaseUrl` returns the `SUPABASE_URL` from `.env.dev` via `Env.supabaseUrl`
- **AND** `AppConfig.supabaseAnonKey` returns the `SUPABASE_ANON_KEY` from `.env.dev` via `Env.supabaseAnonKey`

#### Scenario: No hardcoded secrets in source code
- **WHEN** the `app_config.dart` file is inspected
- **THEN** it contains no hardcoded URL strings or API keys — all values come from `Env` class
