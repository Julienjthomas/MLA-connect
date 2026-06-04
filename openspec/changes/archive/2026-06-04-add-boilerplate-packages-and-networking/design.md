## Context

MLA Connect currently uses `supabase_flutter` SDK for all backend communication — direct client calls from service classes, no HTTP abstraction, no interceptors, no structured error handling. The app is migrating to a custom REST backend with JWT authentication.

Current state:
- 27 Dart files import Supabase directly
- Services use `Supabase.instance.client` as a static accessor
- Models use manual `fromJson` / `toJson`
- No responsive sizing — hardcoded pixel values
- Environment config has hardcoded Supabase URL/key in `AppConfig`
- GetX used for state management and DI (`Get.put`, `Get.lazyPut`)
- Flavor system exists (dev/stg/prod) with `main_dev.dart`, `main_stg.dart`, `main_prod.dart`
- API contract defines ~56 endpoints across 9 modules with two URL patterns: `/citizens/:citizenId/...` and `/constituencies/:constituencyId/...`

## Goals / Non-Goals

**Goals:**
- Establish Dio-based networking layer with JWT auth, token refresh, and error handling
- Set up freezed + json_serializable codegen for type-safe immutable models
- Set up retrofit codegen for type-safe API clients
- Add ScreenUtil for responsive sizing
- Replace hardcoded env values with envied-generated, per-flavor config
- Create example patterns (1 model, 1 API client) that future feature migrations copy

**Non-Goals:**
- Migrate any existing Supabase service to the new API layer
- Remove `supabase_flutter` dependency
- Set up offline caching or local DB
- Create all 56 endpoint clients — only example patterns

## Decisions

### 1. Dio over http package

**Choice**: `dio` with interceptor chain
**Why**: Interceptors handle auth token injection, 401 refresh, error mapping, and logging in one place. `http` package has no interceptor concept — would need manual wrapper per request.
**Alternative**: `http` + custom middleware — simpler but no ecosystem (no retrofit, no built-in retry).

### 2. Retrofit for API clients

**Choice**: `retrofit` code generation from abstract Dart classes
**Why**: AI-driven dev benefits — write interface only, codegen does HTTP plumbing. Type-safe, consistent, less to review. Maps directly to API contract.
**Alternative**: Manual Dio calls per service — flexible but repetitive, error-prone, inconsistent across team/AI.

### 3. Freezed for models

**Choice**: `freezed` + `json_serializable`
**Why**: Generates immutable models, `copyWith`, equality, `fromJson`/`toJson` from ~10 lines. With ~56 endpoints and many response models, manual boilerplate doesn't scale.
**Alternative**: Manual models — no build step, but 4-5x more code per model, easy to introduce bugs in equality/serialization.

### 4. GetX DI — no get_it

**Choice**: Keep GetX DI (`Get.put`, `Get.lazyPut`) for all dependency injection
**Why**: App already uses GetX everywhere. Adding `get_it` creates two DI systems — confusing, no benefit. GetX DI handles singletons and lazy initialization fine.
**Alternative**: `get_it` + `injectable` — more powerful but redundant when GetX is already the framework.

### 5. Envied over flutter_dotenv

**Choice**: `envied` with per-flavor `.env` files
**Why**: Compile-time type safety, obfuscation for secrets, zero runtime overhead. Typo in env key = compile error, not runtime null.
**Alternative**: `flutter_dotenv` — simpler but runtime-only, string-typed, `.env` file shipped as plaintext asset in APK.

### 6. ScreenUtil for responsiveness

**Choice**: `flutter_screenutil` initialized with Figma design size
**Why**: Simple API (`.w`, `.h`, `.sp`), well-adopted, consistent pattern for AI to follow. One init call, then all sizing is responsive.
**Alternative**: `responsive_framework` — more features (breakpoints, auto-scale) but heavier, overkill for a mobile-first app.

### 7. citizenId injection via Dio interceptor

**Choice**: `AuthInterceptor` injects both JWT token AND `citizenId` into request paths
**Why**: ~30 of 56 endpoints use `/citizens/:citizenId/...` pattern. Injecting at interceptor level means API clients never pass citizenId manually — cleaner, less error-prone.
**How**: Store citizenId in secure storage on login. Interceptor replaces `:citizenId` placeholder in URL.

### 8. File structure

```
lib/
├── core/
│   ├── config/
│   │   ├── app_config.dart          (refactored — uses Env)
│   │   ├── app_flavor.dart          (existing)
│   │   └── env/
│   │       ├── env.dart             (envied class)
│   │       └── env.g.dart           (generated)
│   ├── network/
│   │   ├── dio_client.dart          (Dio factory + interceptor wiring)
│   │   ├── api_endpoints.dart       (base URL paths)
│   │   ├── interceptors/
│   │   │   ├── auth_interceptor.dart
│   │   │   ├── error_interceptor.dart
│   │   │   └── token_refresh_interceptor.dart
│   │   └── api_response.dart        (generic wrapper)
│   └── ...
├── data/
│   ├── models/                      (freezed models — new ones here)
│   ├── remote/                      (NEW — retrofit API clients)
│   │   └── config_api.dart          (example retrofit client)
│   └── services/                    (existing Supabase services — untouched)
```

### 9. Error handling pattern

**Choice**: Dio `ErrorInterceptor` maps to typed `AppException` hierarchy
```
AppException
├── NetworkException        (no internet)
├── ServerException         (5xx)
├── UnauthorizedException   (401 after refresh fails)
├── NotFoundException       (404)
├── ValidationException     (422 with field errors)
└── UnknownException        (catch-all)
```
Controllers catch `AppException` subtypes — consistent error UI across app.

### 10. Token refresh flow

```
Request → 401 Response
  → Lock Dio (queue other requests)
  → POST /citizens/:citizenId/auth/refresh
  → Success? → Update stored token → Retry original + queued
  → Fail? → Clear session → Navigate to login
```

## Risks / Trade-offs

- **build_runner learning curve** → Document in project README, add `build.yaml` shortcut script
- **Dual networking during migration** → Supabase SDK and Dio coexist. Acceptable — services migrate one by one in future changes
- **Codegen adds build step** → `dart run build_runner build` after model/API changes. Can use `watch` mode during dev
- **Envied requires rebuild on env change** → Unlike dotenv, changing `.env` needs codegen re-run. Trade-off for type safety
- **ScreenUtil init needs design size** → Must agree on Figma artboard dimensions. Default to 375x812 (iPhone 13 mini) if not specified
