## Why

Auth is the foundation of every API call — JWT token and citizenId stored at login unlock all other migrated modules. Moving auth to the new REST backend is the first step in retiring Supabase entirely.

## What Changes

- Replace `Supabase.instance.client.auth.signInWithOtp` with `POST /auth/otp/send`
- Replace `Supabase.instance.client.auth.verifyOTP` with `POST /auth/otp/verify` → stores JWT + citizenId in secure storage
- Replace Supabase session check (`currentSession`) with JWT presence in secure storage
- Replace Supabase `auth.signOut` with `POST /citizens/:citizenId/auth/logout`
- Token refresh already handled by `TokenRefreshInterceptor` (wired in previous change)
- `AuthController` no longer depends on `supabase_flutter` auth APIs
- `userId` property migrated from Supabase UUID to stored citizenId
- Onboarding routing logic preserved — only the auth mechanism changes

## Capabilities

### New Capabilities

- `rest-auth`: OTP send/verify flow against REST backend, JWT + citizenId storage, logout via REST

### Modified Capabilities

- `auth`: Auth mechanism changes from Supabase OTP to REST API OTP. Session state changes from Supabase session object to JWT in secure storage.
- `auth-session-bootstrap`: Bootstrap logic changes from Supabase session check to JWT presence check.

## Impact

- `lib/features/auth/controllers/auth_controller.dart` — full rewrite of auth methods
- `lib/data/remote/auth_api.dart` — new retrofit client (POST /auth/otp/send, POST /auth/otp/verify, POST logout)
- `lib/data/models/auth/` — new freezed models (OtpSendRequest, OtpVerifyRequest, AuthResponse)
- `lib/core/network/interceptors/auth_interceptor.dart` — already wired, reads from secure storage
- `lib/core/network/interceptors/token_refresh_interceptor.dart` — already wired
- `supabase_flutter` auth imports removed from `AuthController`
