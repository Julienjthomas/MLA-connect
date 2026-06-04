## 1. Models

- [x] 1.1 Create `lib/data/models/appreciation/appreciation_response.dart` — freezed: `{id, citizenId, recipientCategory, staffName?, department?, relatedWork?, message, visibility, anonymous, status, createdAt, mediaUrls}`
- [x] 1.2 Create `lib/data/models/appreciation/create_appreciation_request.dart` — freezed request model
- [x] 1.3 Create `lib/data/models/appreciation/appreciation_comment.dart` — freezed: `{id, citizenId, body, createdAt}`
- [x] 1.4 Run `dart run build_runner build`

## 2. API Client

- [x] 2.1 Create `lib/data/remote/appreciation_api.dart` — retrofit client with:
  - `POST /citizens/:citizenId/appreciations`
  - `GET /citizens/:citizenId/appreciations`
  - `GET /citizens/:citizenId/appreciations/:appreciationId`
  - `DELETE /citizens/:citizenId/appreciations/:appreciationId`
  - `GET /constituencies/{constituencyId}/appreciations`
  - `GET /constituencies/{constituencyId}/appreciations/{appreciationId}`
  - `POST /constituencies/{constituencyId}/appreciations/{appreciationId}/like`
  - `GET /constituencies/{constituencyId}/appreciations/{appreciationId}/comments`
  - `POST /constituencies/{constituencyId}/appreciations/{appreciationId}/comments`
  - `DELETE /constituencies/{constituencyId}/appreciations/{appreciationId}/comments/{commentId}`
- [x] 2.2 Run `dart run build_runner build`
- [x] 2.3 Register `AppreciationApi` in DI in all 3 entry points

## 3. Rewrite Service

- [x] 3.1 Rewrite `lib/data/services/appreciation_service.dart` — use `AppreciationApi`, map response → `AppreciationModel`
- [x] 3.2 Remove supabase imports

## 4. Verify

- [x] 4.1 Run `flutter analyze` — no errors
- [x] 4.2 Run app — appreciations list loads [manual]
