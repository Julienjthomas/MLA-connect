## Why

`MlaService` and `PublicBoardService` directly query Supabase tables. New backend exposes clean MLA and constituency endpoints. Migrating removes two more Supabase services.

## What Changes

- Create `MlaResponse` freezed model matching `GET /constituencies/:constituencyId/mla`
- Create `ConstituencySummaryResponse` freezed model
- Create `MlaApi` retrofit client — MLA, constituency summary, recent posts, trending appreciations, top ideas, upcoming events
- Create `PublicBoardApi` retrofit client — constituency-scoped concerns/ideas/appreciations (reuse existing concern/idea/appreciation models)
- Rewrite `MlaService` to use `MlaApi`
- Rewrite `PublicBoardService` to use `PublicBoardApi`

## Capabilities

### New Capabilities
- `rest-mla-constituency`: MLA profile + constituency summary via REST

### Modified Capabilities
- `mla-layer`: MLA data sourced from REST API
- `mla-profile`: MLA profile fetch uses REST

## Impact
- `lib/data/models/mla/` — new freezed models
- `lib/data/remote/mla_api.dart` — new retrofit client
- `lib/data/services/mla_service.dart` — rewrite
- `lib/data/services/public_board_service.dart` — rewrite using existing concern/idea/appreciation APIs
