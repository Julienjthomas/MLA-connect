## Why

`IdeaService` directly queries the Supabase `submissions` table with complex joins for media. The new backend exposes clean `/ideas` endpoints. Migrating removes Supabase dependency from the ideas flow.

## What Changes

- Create `IdeaResponse` (freezed) — maps REST `/ideas` response fields
- Create `CreateIdeaRequest` (freezed) — request body for POST
- Create `IdeaApi` retrofit client (citizen-scoped + constituency-scoped)
- Rewrite `IdeaService` to use `IdeaApi`
- Constituency-scoped: list, get, upvote, downvote, comments CRUD
- Preserve `IdeaModel` interface — map from API response to keep controllers unchanged

## Capabilities

### New Capabilities

- `rest-ideas`: Full citizen + constituency idea CRUD via REST API

### Modified Capabilities

- `share-idea`: Idea submission now goes to REST API instead of Supabase

## Impact

- `lib/data/models/idea/` — new freezed models
- `lib/data/remote/idea_api.dart` — new retrofit client
- `lib/data/services/idea_service.dart` — rewrite
