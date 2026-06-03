## 1. Add Packages

- [x] 1.1 Add dependencies to `pubspec.yaml`: `dio`, `retrofit`, `pretty_dio_logger`, `connectivity_plus`, `freezed_annotation`, `json_annotation`, `flutter_screenutil`, `envied`, `logger`
- [x] 1.2 Add dev dependencies to `pubspec.yaml`: `build_runner`, `retrofit_generator`, `freezed`, `json_serializable`, `envied_generator`
- [x] 1.3 Run `flutter pub get` and verify no version conflicts

## 2. Environment Config (envied)

- [x] 2.1 Create `.env.example` at project root with all required keys: `BASE_URL`, `SUPABASE_URL`, `SUPABASE_ANON_KEY`
- [x] 2.2 Create `.env.dev`, `.env.stg`, `.env.prod` with actual values (Supabase values from current `AppConfig`, `BASE_URL` as placeholder)
- [x] 2.3 Add `.env.dev`, `.env.stg`, `.env.prod` to `.gitignore`
- [x] 2.4 Create `lib/core/config/env/env.dart` with `@Envied` class exposing `baseUrl`, `supabaseUrl`, `supabaseAnonKey`
- [x] 2.5 Run `dart run build_runner build` to generate `env.g.dart`
- [x] 2.6 Refactor `lib/core/config/app_config.dart` to read from `Env` class instead of hardcoded strings
- [x] 2.7 Update `main_dev.dart`, `main_stg.dart`, `main_prod.dart` entry points to load correct env before `AppConfig.init()`

## 3. Networking Layer

- [x] 3.1 Create `lib/core/network/api_exceptions.dart` with `AppException` hierarchy (`NetworkException`, `ServerException`, `UnauthorizedException`, `NotFoundException`, `ValidationException`, `UnknownException`)
- [x] 3.2 Create `lib/core/network/interceptors/auth_interceptor.dart` — inject JWT token from secure storage + replace `:citizenId` in URL paths
- [x] 3.3 Create `lib/core/network/interceptors/error_interceptor.dart` — map Dio errors to `AppException` subtypes
- [x] 3.4 Create `lib/core/network/interceptors/token_refresh_interceptor.dart` — handle 401 → refresh → retry with request queue locking
- [x] 3.5 Create `lib/core/network/dio_client.dart` — Dio factory that wires interceptors (`auth`, `error`, `token_refresh`, `pretty_dio_logger` in debug only)
- [x] 3.6 Create `lib/core/network/api_response.dart` — generic API response wrapper if needed
- [x] 3.7 Register Dio singleton in GetX DI — add `Get.put<Dio>(DioClient.create())` in app initialization

## 4. Model Codegen Pattern

- [x] 4.1 Create `lib/data/models/app_config_model.dart` as example freezed model (matching `GET /app-config` response shape)
- [x] 4.2 Run `build_runner` and verify `.freezed.dart` + `.g.dart` generate correctly

## 5. Retrofit API Client Pattern

- [x] 5.1 Create `lib/core/network/api_endpoints.dart` with base path constants
- [x] 5.2 Create `lib/data/remote/config_api.dart` as example retrofit client for `GET /app-config`
- [x] 5.3 Run `build_runner` and verify `.g.dart` generates correctly
- [x] 5.4 Register example API client in GetX DI to demonstrate the pattern

## 6. Responsive UI (ScreenUtil)

- [x] 6.1 Wrap `GetMaterialApp` in `lib/app.dart` with `ScreenUtilInit` (designSize: 375x812)
- [x] 6.2 Verify app builds and launches correctly with ScreenUtil wrapper

## 7. Build & Verify

- [x] 7.1 Create `build.yaml` if needed for build_runner configuration
- [x] 7.2 Run full `dart run build_runner build --delete-conflicting-outputs` — all codegen passes
- [x] 7.3 Run `flutter analyze` — no errors
- [x] 7.4 Run app on emulator — launches without crashes, existing Supabase features still work
