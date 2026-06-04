## Why

`AppreciationService` directly queries Supabase `submissions` with media joins. New backend exposes `/appreciations` endpoints. Migrating removes the final citizen-submission Supabase service.

## What Changes

- Create `AppreciationResponse` (freezed) — maps REST `/appreciations` response
- Create `CreateAppreciationRequest` (freezed) — request body
- Create `AppreciationApi` retrofit client (citizen-scoped + constituency-scoped)
- Rewrite `AppreciationService` to use `AppreciationApi`
- Constituency-scoped: list, get, like, comments CRUD
- Preserve `AppreciationModel` interface — map from API response

## Capabilities

### New Capabilities

- `rest-appreciations`: Full citizen + constituency appreciation CRUD via REST API

### Modified Capabilities

- `appreciation`: Appreciation submission now uses REST API

## Impact

- `lib/data/models/appreciation/` — new freezed models
- `lib/data/remote/appreciation_api.dart` — new retrofit client
- `lib/data/services/appreciation_service.dart` — rewrite
