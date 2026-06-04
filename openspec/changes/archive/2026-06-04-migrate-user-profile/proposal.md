## Why

`UserService` is the only remaining blocker for fully decoupling from Supabase in auth and onboarding flows. It currently talks directly to Supabase tables (`citizens`, `local_bodies`, `wards`, `constituencies`). Migrating it to the new REST API unlocks profile fetch, profile update, onboarding save, and geography selection — all against the new backend.

## What Changes

- Replace `UserService.getProfile` with `GET /citizens/:citizenId/profile`
- Replace `UserService.createProfile` / `updateProfile` with `POST /citizens/:citizenId/profile/update` and `POST /citizens/:citizenId/basic-info/personal-info`
- Replace `UserService.getConstituencies` with `GET /constituencies` (Geography — optional API)
- Replace `UserService.getLocalBodies` with `GET /constituencies/:constituencyId/local-bodies`
- Replace `UserService.getWards` with `GET /constituencies/:constituencyId/local-bodies/:localBodyId/wards`
- Replace `UserService.saveConstituencySelection` with `POST /citizens/:citizenId/basic-info/personal-info`
- Replace `UserService.saveNotificationPrefs` with `PUT /citizens/:citizenId/settings`
- Create freezed models for profile + geography API responses
- Remove Supabase imports from `UserService` and `OnboardingController`
- Remove `AuthController` TODO comments — profile load now uses REST

## Capabilities

### New Capabilities

- `rest-user-profile`: REST-backed citizen profile fetch and update
- `rest-geography`: REST-backed constituencies, local bodies, wards

### Modified Capabilities

- `user-profile-layer`: Profile CRUD migrated from Supabase direct to REST API
- `geography-layer`: Geography data sourced from REST API with seed fallback preserved

## Impact

- `lib/data/services/user_service.dart` — full rewrite, Supabase removed
- `lib/data/remote/profile_api.dart` — new retrofit client
- `lib/data/remote/geography_api.dart` — new retrofit client
- `lib/data/models/profile/` — new freezed models (CitizenProfile, UpdateProfileRequest, etc.)
- `lib/features/auth/controllers/auth_controller.dart` — remove TODO, use REST profile
- `lib/features/onboarding/controllers/onboarding_controller.dart` — uses new UserService
- Seed fallback for geography preserved — used when REST returns empty or fails
