## Context

Current auth uses Supabase SDK directly — `signInWithOtp`, `verifyOTP`, `signOut`, and session state all via `Supabase.instance.client.auth`. The new backend exposes its own OTP flow (`POST /auth/otp/send`, `POST /auth/otp/verify`) returning a JWT token and citizenId.

The Dio networking layer (interceptors, token refresh) is already wired from the previous change. This change replaces only the auth data source — controllers, views, and routing logic stay the same.

## Goals / Non-Goals

**Goals:**
- Replace all Supabase auth calls in `AuthController` with new REST API
- Store JWT token + citizenId in secure storage on successful verify
- `isLoggedIn` and `userId` derived from secure storage instead of Supabase session
- Onboarding routing logic untouched
- `bootstrapSession` checks JWT presence instead of Supabase session

**Non-Goals:**
- Migrating citizen profile fetch (`UserService`) — stays on Supabase for now
- Migrating onboarding save (`saveProfile`) — stays on Supabase for now
- Removing `supabase_flutter` package — depends on other services still using it
- UI changes to phone/OTP views

## Decisions

### 1. Retrofit client for auth endpoints

`AuthApi` (retrofit) handles `POST /auth/otp/send` and `POST /auth/otp/verify`. Registered via `Get.lazyPut` so it uses the shared Dio instance with all interceptors.

### 2. JWT + citizenId stored in FlutterSecureStorage

On `verifyOtp` success, the response `{token, isNewUser, citizenId}` is written to secure storage:
- `auth_token` → JWT (read by `AuthInterceptor`)
- `citizen_id` → citizenId (read by `AuthInterceptor` for URL path replacement)
- `refresh_token` → if present in response

`isLoggedIn` checks `auth_token` key presence. `userId` reads `citizen_id`.

### 3. AuthController stays sync-capable via RxBool

Since session check is now async (secure storage read), `isLoggedIn` becomes a cached `RxBool` populated at `onInit` / `bootstrapSession`. Avoids making `isLoggedIn` a Future throughout the codebase.

### 4. Auth API client does NOT use TokenRefreshInterceptor for OTP endpoints

OTP send/verify are public — no token needed. The `AuthInterceptor` skips injection when no token is stored, so no special handling needed.

### 5. Logout calls REST then clears storage

`POST /citizens/:citizenId/auth/logout` called first (best-effort), then secure storage cleared. If the request fails (network error), storage is still cleared — local logout always succeeds.

### 6. Phone normalization stays in AuthController

`_normalizePhone` stays unchanged — `+91` prefix logic is app-side responsibility.

## Risks / Trade-offs

- **`bootstrapSession` now async for login check** → `isLoggedIn` must be awaited at splash. Current `bootstrapSession` already async — low risk.
- **citizenId not available on first login if backend doesn't return it** → API contract shows `verifyOtp` returns `{token, isNewUser}` — need to confirm citizenId is included. Flag for backend team.
- **Supabase profile fetch still uses Supabase session internally** → `UserService.getProfile` uses Supabase user ID as key. Short-term, citizenId stored from JWT response can replace this. For now, keep Supabase profile fetch until `UserService` is migrated.
