## 1. Models

- [x] 1.1 Create `lib/data/models/event/public_event_response.dart` — freezed: `{id, title, description?, kind, startsAt, endsAt?, venueName?, venueAddress?, coverImageUrl?, createdAt}`
- [x] 1.2 Run `dart run build_runner build`

## 2. API Client

- [x] 2.1 Create `lib/data/remote/events_api.dart` — retrofit:
  - `GET /constituencies/{constituencyId}/public-events`
  - `GET /constituencies/{constituencyId}/public-events/{eventId}`
  - `POST /constituencies/{constituencyId}/public-events/{eventId}/show-interest`
  - `GET /constituencies/public-events/upcoming`
- [x] 2.2 Run `dart run build_runner build`
- [x] 2.3 Register `EventsApi` in DI in all 3 entry points

## 3. Rewrite Service

- [x] 3.1 Rewrite `lib/data/services/event_service.dart` — use `EventsApi`, map `PublicEventResponse` → `EventModel`
- [x] 3.2 Remove supabase imports

## 4. Verify

- [x] 4.1 Run `flutter analyze` — no errors
- [x] 4.2 Run app — events load [manual]
