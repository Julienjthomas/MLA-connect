## 1. Models

- [x] 1.1 Create `lib/data/models/idea/idea_response.dart` — freezed: `{id, citizenId, topic, title, description, benefits?, beneficiaries, visibility, allowDiscussion, allowContact, status, createdAt, mediaUrls, upvotes, downvotes}`
- [x] 1.2 Create `lib/data/models/idea/create_idea_request.dart` — freezed request model
- [x] 1.3 Create `lib/data/models/idea/idea_comment.dart` — freezed: `{id, citizenId, body, createdAt}`
- [x] 1.4 Run `dart run build_runner build`

## 2. API Client

- [x] 2.1 Create `lib/data/remote/idea_api.dart` — retrofit client with:
  - `POST /citizens/:citizenId/ideas`
  - `GET /citizens/:citizenId/ideas`
  - `GET /citizens/:citizenId/ideas/:ideaId`
  - `DELETE /citizens/:citizenId/ideas/:ideaId`
  - `GET /constituencies/{constituencyId}/ideas`
  - `GET /constituencies/{constituencyId}/ideas/{ideaId}`
  - `POST /constituencies/{constituencyId}/ideas/{ideaId}/upvote`
  - `POST /constituencies/{constituencyId}/ideas/{ideaId}/downvote`
  - `GET /constituencies/{constituencyId}/ideas/{ideaId}/comments`
  - `POST /constituencies/{constituencyId}/ideas/{ideaId}/comments`
  - `DELETE /constituencies/{constituencyId}/ideas/{ideaId}/comments/{commentId}`
- [x] 2.2 Run `dart run build_runner build`
- [x] 2.3 Register `IdeaApi` in DI in all 3 entry points

## 3. Rewrite Service

- [x] 3.1 Rewrite `lib/data/services/idea_service.dart` — use `IdeaApi`, map response → `IdeaModel`
- [x] 3.2 Remove supabase imports

## 4. Verify

- [x] 4.1 Run `flutter analyze` — no errors
- [x] 4.2 Run app — ideas list loads [manual]
