## Context

Straightforward service migration — replace Supabase direct calls with retrofit API client. Existing model interfaces preserved so controllers require no changes.

## Goals / Non-Goals

**Goals:**
- Replace Supabase calls with REST API via retrofit client
- Preserve existing model interfaces for controllers
- Remove supabase_flutter imports from migrated services

**Non-Goals:**
- UI changes
- Controller refactoring

## Decisions

- Retrofit client injected via GetX `Get.find<>()` inside service
- Map REST response model → existing app model in service layer
- Keep existing model classes untouched — controllers stay unchanged

## Risks / Trade-offs

- REST response field names assumed from contract — may need `@JsonKey` adjustments when tested
