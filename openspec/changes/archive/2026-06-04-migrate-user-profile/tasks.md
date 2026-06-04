## 1. Models

- [x] 1.1 Create `lib/data/models/profile/citizen_profile.dart` — freezed model matching `GET /citizens/:citizenId/profile` response (id, name, phone, email, avatarUrl, language, constituencyId, constituencyName, localBodyId, localBodyName, wardId, wardName, onboardedAt)
- [x] 1.2 Create `lib/data/models/profile/update_profile_request.dart` — freezed model for `POST /citizens/:citizenId/profile/update`
- [x] 1.3 Create `lib/data/models/profile/personal_info_request.dart` — freezed model for `POST /citizens/:citizenId/basic-info/personal-info`
- [x] 1.4 Create `lib/data/models/geography/constituency_response.dart` — freezed model for `GET /constituencies` item
- [x] 1.5 Create `lib/data/models/geography/local_body_response.dart` — freezed model for local body item
- [x] 1.6 Create `lib/data/models/geography/ward_response.dart` — freezed model for ward item
- [x] 1.7 Run `dart run build_runner build` — verify all codegen passes

## 2. API Clients

- [x] 2.1 Create `lib/data/remote/profile_api.dart` — retrofit client: `GET /citizens/:citizenId/profile`, `POST /citizens/:citizenId/profile/update`, `POST /citizens/:citizenId/basic-info/personal-info`, `PUT /citizens/:citizenId/settings`
- [x] 2.2 Create `lib/data/remote/geography_api.dart` — retrofit client: `GET /constituencies`, `GET /constituencies/{constituencyId}/local-bodies`, `GET /constituencies/{constituencyId}/local-bodies/{localBodyId}/wards`
- [x] 2.3 Run `dart run build_runner build` — verify both `.g.dart` files generated
- [x] 2.4 Register `ProfileApi` and `GeographyApi` in GetX DI in all 3 entry points

## 3. Rewrite UserService

- [x] 3.1 Replace `getProfile(userId)` — call `ProfileApi.getProfile()`, map `CitizenProfile` → `UserModel`
- [x] 3.2 Replace `createProfile(data)` — call `ProfileApi.savePersonalInfo()` with mapped payload
- [x] 3.3 Replace `updateProfile(userId, data)` — call `ProfileApi.updateProfile()` with data
- [x] 3.4 Replace `saveConstituencySelection` — call `ProfileApi.savePersonalInfo()` with constituencyId only
- [x] 3.5 Replace `getConstituencies()` — call `GeographyApi.getConstituencies()`, fallback to seed on empty/error
- [x] 3.6 Replace `getLocalBodies()` — call `GeographyApi.getLocalBodies(constituencyId)`, fallback to seed
- [x] 3.7 Replace `getWards()` — call `GeographyApi.getWards(constituencyId, localBodyId)`, fallback to synthetic
- [x] 3.8 Replace `saveNotificationPrefs()` — call `ProfileApi.updateSettings()` with prefs map
- [x] 3.9 Remove all `supabase_flutter` imports from `UserService`

## 4. Update AuthController

- [x] 4.1 Remove `supabase_flutter` uid dependency from `_loadUserIfLoggedIn` — use stored `citizenId` with `UserService.getProfile(citizenId)`
- [x] 4.2 Remove `saveProfile` Supabase uid dependency — use citizenId from secure storage
- [x] 4.3 Remove `updateBasicProfile` and `updateLanguage` Supabase uid dependency
- [x] 4.4 Remove all `// TODO: Replace...` comments from AuthController

## 5. Verify

- [x] 5.1 Run `flutter analyze` — no errors
- [ ] 5.2 Run app — onboarding constituency/local body/ward selection loads correctly
- [ ] 5.3 Run app — profile screen shows correct citizen data
- [ ] 5.4 Run app — language switch persists correctly
