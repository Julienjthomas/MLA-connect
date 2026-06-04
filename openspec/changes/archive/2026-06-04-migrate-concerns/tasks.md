## 1. Models

- [x] 1.1 Create `lib/data/models/concern/concern_model.dart` — freezed: `{id, citizenId, category, title, description, location?, landmark?, voiceNoteUrl?, wardId?, wardName?, contactNumber?, status, createdAt, mediaUrls, timeline?}`
- [x] 1.2 Create `lib/data/models/concern/create_concern_request.dart` — freezed request model
- [x] 1.3 Create `lib/data/models/concern/concern_comment.dart` — freezed: `{id, citizenId, body, createdAt}`
- [x] 1.4 Run `dart run build_runner build`

## 2. API Client

- [x] 2.1 Create `lib/data/remote/concern_api.dart` — retrofit client with:
  - `POST /citizens/:citizenId/concerns`
  - `GET /citizens/:citizenId/concerns`
  - `GET /citizens/:citizenId/concerns/:concernId`
  - `DELETE /citizens/:citizenId/concerns/:concernId`
  - `GET /constituencies/{constituencyId}/concerns`
  - `GET /constituencies/{constituencyId}/concerns/{concernId}`
  - `POST /constituencies/{constituencyId}/concerns/{concernId}/like`
  - `GET /constituencies/{constituencyId}/concerns/{concernId}/comments`
  - `POST /constituencies/{constituencyId}/concerns/{concernId}/comments`
  - `DELETE /constituencies/{constituencyId}/concerns/{concernId}/comments/{commentId}`
- [x] 2.2 Run `dart run build_runner build`
- [x] 2.3 Register `ConcernApi` in DI in all 3 entry points

## 3. Rewrite Services

- [x] 3.1 Rewrite `lib/data/services/improvement_service.dart` — use `ConcernApi`, map `ConcernModel` → `ImprovementModel`
- [x] 3.2 Rewrite `lib/data/services/report_service.dart` — use `ConcernApi`, map `ConcernModel` → `ReportModel`
- [x] 3.3 Remove supabase imports from both services

## 4. Verify

- [x] 4.1 Run `flutter analyze` — no errors
- [x] 4.2 Run app — improvements list loads [manual]
- [x] 4.3 Run app — reports list loads [manual]
