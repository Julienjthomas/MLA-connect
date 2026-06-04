## 1. Models

- [x] 1.1 Create `lib/data/models/auth/otp_send_request.dart` — freezed model `{phone: String}`
- [x] 1.2 Create `lib/data/models/auth/otp_verify_request.dart` — freezed model `{phone: String, otp: String}`
- [x] 1.3 Create `lib/data/models/auth/auth_response.dart` — freezed model `{token: String, isNewUser: bool, citizenId: String}`
- [x] 1.4 Run `dart run build_runner build` — verify all model codegen passes

## 2. Auth API Client

- [x] 2.1 Create `lib/data/remote/auth_api.dart` — retrofit client with `POST /auth/otp/send` and `POST /auth/otp/verify`
- [x] 2.2 Run `dart run build_runner build` — verify `auth_api.g.dart` generated
- [x] 2.3 Register `AuthApi` in GetX DI — `Get.lazyPut(() => AuthApi(Get.find<Dio>()))` in `main_dev.dart`, `main_stg.dart`, `main_prod.dart`

## 3. Migrate AuthController

- [x] 3.1 Add `FlutterSecureStorage` and `AuthApi` dependencies to `AuthController`
- [x] 3.2 Replace `isLoggedIn` — read `auth_token` from secure storage (cached `RxBool`, populated at `onInit`)
- [x] 3.3 Replace `userId` — read `citizen_id` from secure storage
- [x] 3.4 Replace `sendOtp()` — call `AuthApi.sendOtp()` instead of Supabase
- [x] 3.5 Replace `verifyOtp()` — call `AuthApi.verifyOtp()`, on success write `auth_token` + `citizen_id` + `refresh_token` to secure storage
- [x] 3.6 Replace `logout()` — call `POST /citizens/:citizenId/auth/logout` (best-effort), then clear `auth_token`, `citizen_id`, `refresh_token` from secure storage
- [x] 3.7 Remove `Supabase.instance.client.auth.onAuthStateChange` subscription — replace with secure storage-based session awareness
- [x] 3.8 Update `bootstrapSession()` — check `auth_token` presence instead of `Supabase session`
- [x] 3.9 Remove all `supabase_flutter` auth imports from `AuthController`

## 4. Verify & Analyze

- [x] 4.1 Run `flutter analyze` — no errors in auth module
- [ ] 4.2 Run app locally against `localhost:3000` — OTP send completes without crash [manual]
- [ ] 4.3 Verify OTP verify → JWT stored → navigates correctly (new user to onboarding, returning user to home) [manual]
- [ ] 4.4 Verify logout → clears storage → routes to welcome [manual]
- [ ] 4.5 Verify app restart → JWT present → bootstrapSession runs → routes correctly [manual]
