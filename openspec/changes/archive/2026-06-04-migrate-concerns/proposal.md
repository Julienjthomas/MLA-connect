## Why

The current app has two separate submission types — "reports" (problems) and "improvements" (suggestions) — both stored in a Supabase `submissions` table. The new backend unifies these under a single **concerns** module. Migrating `improvement_service` and `report_service` to `/concerns` endpoints removes two Supabase services and enables the full citizen submission flow against the REST backend.

## What Changes

- Create `ConcernModel` (freezed) — unified model covering both old report + improvement fields
- Replace `ImprovementService` with REST `POST /citizens/:citizenId/concerns` and `GET /citizens/:citizenId/concerns`
- Replace `ReportService` with the same concern endpoints (category field distinguishes type)
- Create `ConcernApi` retrofit client (citizen-scoped + constituency-scoped endpoints)
- Constituency-scoped: GET concerns, like, comments CRUD
- Preserve `ImprovementModel` and `ReportModel` — map from `ConcernModel` to avoid UI changes
- **BREAKING**: `ImprovementFormData.toJson` and `ReportFormData.toJson` replaced by `CreateConcernRequest`

## Capabilities

### New Capabilities

- `rest-concerns`: Full citizen + constituency concern CRUD via REST API

### Modified Capabilities

- `submissions-layer`: Concern submissions now go to REST API instead of Supabase submissions table

## Impact

- `lib/data/models/concern/` — new freezed models
- `lib/data/remote/concern_api.dart` — new retrofit client
- `lib/data/services/improvement_service.dart` — rewrite to use ConcernApi
- `lib/data/services/report_service.dart` — rewrite to use ConcernApi
- `lib/features/improvements/` and `lib/features/report/` controllers — update service calls
