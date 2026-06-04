## 1. Models

- [x] 1.1 Create `lib/data/models/mla/mla_response.dart` — freezed: `{id, name, photoUrl?, coverImageUrl?, bio, bioMl?, term, constituency, education?, galleryUrls, stats, contact, initiatives}`
- [x] 1.2 Create `lib/data/models/mla/constituency_summary_response.dart` — freezed: `{id, name, constituencyId, stats?}`
- [x] 1.3 Run `dart run build_runner build`

## 2. API Client

- [x] 2.1 Create `lib/data/remote/mla_api.dart` — retrofit:
  - `GET /constituencies/{constituencyId}/mla`
  - `GET /constituencies/{constituencyId}/summary`
  - `GET /constituencies/posts/recent`
  - `GET /constituencies/appreciations/trending`
  - `GET /constituencies/ideas/top`
  - `GET /constituencies/public-events/upcoming`
- [x] 2.2 Run `dart run build_runner build`
- [x] 2.3 Register `MlaApi` in DI in all 3 entry points

## 3. Rewrite Services

- [x] 3.1 Rewrite `lib/data/services/mla_service.dart` — use `MlaApi`, map `MlaResponse` → `MlaModel`
- [x] 3.2 Rewrite `lib/data/services/public_board_service.dart` — use existing `ConcernApi`/`IdeaApi`/`AppreciationApi` for constituency-scoped data
- [x] 3.3 Remove supabase imports from both services

## 4. Verify

- [x] 4.1 Run `flutter analyze` — no errors
- [x] 4.2 Run app — MLA profile loads [manual]
