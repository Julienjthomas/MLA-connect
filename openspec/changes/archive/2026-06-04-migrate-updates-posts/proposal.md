## Why

`UpdatesService` queries Supabase posts table with complex media URL signing logic. New backend exposes clean `/posts` endpoints with direct media URLs.

## What Changes

- Create `PostResponse` freezed model (maps to existing `UpdateModel`)
- Create `UpdatesApi` retrofit client — constituency posts, single post, like/unlike, recent posts
- Rewrite `UpdatesService` to use `UpdatesApi`
- Remove Supabase URL signing logic (backend serves signed URLs directly)

## Capabilities

### New Capabilities
- `rest-updates-posts`: MLA posts via REST API

### Modified Capabilities
- `updates-feed`: Posts data sourced from REST

## Impact
- `lib/data/models/post/` — new freezed model
- `lib/data/remote/updates_api.dart` — new retrofit client
- `lib/data/services/updates_service.dart` — rewrite
