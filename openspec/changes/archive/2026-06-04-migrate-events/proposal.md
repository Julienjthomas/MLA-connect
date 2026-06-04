## Why

`EventService` queries Supabase events table. New backend exposes `/public-events` endpoints.

## What Changes

- Create `PublicEventResponse` freezed model (maps to `EventModel`)
- Create `EventsApi` retrofit client — constituency events, single event, upcoming events, show interest
- Rewrite `EventService` to use `EventsApi`

## Capabilities

### New Capabilities
- `rest-events`: Public events via REST API

## Impact
- `lib/data/models/event/` — new freezed model
- `lib/data/remote/events_api.dart` — new retrofit client
- `lib/data/services/event_service.dart` — rewrite
