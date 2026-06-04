## Why

The app currently makes all backend calls directly through the Supabase SDK — no HTTP layer, no interceptors, no structured error handling. We're migrating to a proper REST backend with JWT auth. Before building features against the new API, we need the networking foundation, model codegen, responsive UI utilities, and environment config in place. This is the boilerplate that every feature will build on.

## What Changes

### Add Packages

**Dependencies:**
- `dio` — HTTP client with interceptors
- `retrofit` — type-safe REST client codegen
- `pretty_dio_logger` — debug request/response logging
- `connectivity_plus` — network status detection
- `freezed_annotation` — immutable model annotations
- `json_annotation` — JSON serialization annotations
- `flutter_screenutil` — responsive sizing (`.w`, `.h`, `.sp`)
- `envied` — type-safe environment variables from `.env` files
- `logger` — structured logging

**Dev Dependencies:**
- `build_runner` — code generator runner
- `retrofit_generator` — generates retrofit API clients
- `freezed` — generates immutable models
- `json_serializable` — generates JSON serialization
- `envied_generator` — generates env config

### Set Up Networking Layer

- Create `Dio` singleton configured in GetX DI (`Get.put`)
- Add `AuthInterceptor` — injects JWT token from secure storage into every request
- Add `ErrorInterceptor` — maps HTTP errors to app-level failures
- Add `TokenRefreshInterceptor` — handles 401 → refresh token → retry
- Add `pretty_dio_logger` in debug mode only

### Set Up Environment Config

- Create `.env.dev`, `.env.stg`, `.env.prod` with `BASE_URL` and future keys
- Replace hardcoded Supabase URL/key in `AppConfig` with envied-generated config
- Wire env file selection to existing flavor system

### Set Up Responsive Foundation

- Initialize `ScreenUtilInit` in `app.dart` with design size
- Establish sizing conventions for the codebase

### Create Example Patterns

- One example `freezed` model showing the pattern for future models
- One example `retrofit` API client showing the pattern for future endpoints

## Capabilities

### New Capabilities

- `networking-foundation`: Dio HTTP client with auth, error, and refresh interceptors managed via GetX DI
- `model-codegen`: Freezed + json_serializable pattern for type-safe immutable models
- `responsive-ui`: ScreenUtil initialization and sizing conventions
- `env-config`: Type-safe per-flavor environment configuration via envied

### Modified Capabilities

- `app-config`: AppConfig switches from hardcoded Supabase values to envied-generated env config

## Impact

- `pubspec.yaml` — new dependencies and dev_dependencies
- `lib/core/config/app_config.dart` — refactored to use envied
- `lib/core/config/env/` — new envied config classes
- `lib/core/network/` — new Dio setup, interceptors
- `lib/app.dart` — ScreenUtil initialization
- `.env.dev`, `.env.stg`, `.env.prod` — new env files
- `.gitignore` — add `.env.*` files

## Non-Goals

- Migrating existing Supabase services to the new API layer (separate change per feature)
- Offline caching / Hive setup (deferred)
- Removing `supabase_flutter` package (stays until all services migrated)

## Risks

- `build_runner` adds codegen step to dev workflow — team needs to run `dart run build_runner build` after model/API changes
- Dual networking (Supabase SDK + Dio) during migration period — acceptable, temporary
