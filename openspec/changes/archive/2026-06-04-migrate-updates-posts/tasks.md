## 1. Models

- [x] 1.1 Create `lib/data/models/post/post_response.dart` — freezed: `{id, title, body, titleMl?, bodyMl?, category, imageUrl?, mediaUrls, likes, views, isFeatured, createdAt}`
- [x] 1.2 Run `dart run build_runner build`

## 2. API Client

- [x] 2.1 Create `lib/data/remote/updates_api.dart` — retrofit:
  - `GET /constituencies/{constituencyId}/posts`
  - `GET /constituencies/{constituencyId}/posts/{postId}`
  - `POST /constituencies/{constituencyId}/posts/{postId}/like`
  - `GET /constituencies/posts/recent`
- [x] 2.2 Run `dart run build_runner build`
- [x] 2.3 Register `UpdatesApi` in DI in all 3 entry points

## 3. Rewrite Service

- [x] 3.1 Rewrite `lib/data/services/updates_service.dart` — use `UpdatesApi`, map `PostResponse` → `UpdateModel`
- [x] 3.2 Remove Supabase URL signing logic — backend serves direct URLs
- [x] 3.3 Remove supabase imports

## 4. Verify

- [x] 4.1 Run `flutter analyze` — no errors
- [x] 4.2 Run app — updates feed loads [manual]
