## Context

`UserService` currently makes 8+ direct Supabase table queries (citizens, constituencies, local_bodies, wards, notification_preferences). It also has complex seed-based fallbacks for geography when DB rows don't exist. The new backend exposes clean REST endpoints for all of this.

The service is used by:
- `AuthController` — getProfile, createProfile, updateProfile, updateLanguage
- `OnboardingController` — getConstituencies, getLocalBodies, getWards, saveConstituencySelection
- `NotificationsSetupController` — saveNotificationPrefs

## Goals / Non-Goals

**Goals:**
- Replace all Supabase table queries in UserService with REST API calls
- Preserve seed fallback logic for geography (REST may return empty on dev)
- UserModel interface stays the same — callers don't change
- Remove supabase_flutter imports from UserService and OnboardingController

**Non-Goals:**
- Changing UserModel shape — callers rely on current fields
- Migrating StorageService (S3 upload — separate change)
- Migrating notification preferences UI flow

## Decisions

### 1. UserService stays as the service abstraction

`UserService` keeps the same method signatures. Only the internals change (Supabase → Dio/retrofit). Controllers don't need to change.

### 2. Two retrofit clients — ProfileApi and GeographyApi

Split by concern:
- `ProfileApi`: citizen profile CRUD (`GET/POST /citizens/:citizenId/...`)
- `GeographyApi`: geography lookups (`GET /constituencies/...`)

Both injected into UserService via constructor or Get.find.

### 3. CitizenProfile freezed model maps to UserModel

API returns `CitizenProfile` (REST shape). `UserService.getProfile` maps it to `UserModel` to keep the existing interface intact. No cascade changes to controllers.

### 4. Geography seed fallback preserved

`getConstituencies`, `getLocalBodies`, `getWards` — if REST returns empty list or throws, fall back to seed data. Same behavior as current Supabase fallback. Critical for dev environment.

### 5. saveConstituencySelection uses basic-info/personal-info

`POST /citizens/:citizenId/basic-info/personal-info` accepts partial profile updates — used for constituency selection during onboarding.

### 6. saveNotificationPrefs uses settings endpoint

`PUT /citizens/:citizenId/settings` replaces `notification_preferences` upsert.

### 7. AuthController profile load simplified

Remove Supabase uid dependency for profile load — use stored citizenId directly with `GET /citizens/:citizenId/profile`.

## Risks / Trade-offs

- **API response shape unknown** — CitizenProfile model fields assumed from contract. May need adjustment when tested against real backend.
- **Geography seed fallback** — if REST geography returns data in a different shape than expected, fallback kicks in silently. Add debug logging.
- **saveConstituencySelection partial update** — backend must accept partial `personal-info` payload (only constituencyId). Confirm with backend team.
