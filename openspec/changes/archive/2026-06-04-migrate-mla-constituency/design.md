## Context

Straightforward service migration — replace Supabase direct calls with retrofit API client. Existing model interfaces preserved where controllers depend on them.

## Goals / Non-Goals

**Goals:**
- Replace Supabase calls with REST API via retrofit client
- Map REST response models → existing app models to keep controllers unchanged
- Remove supabase_flutter imports from migrated services

**Non-Goals:**
- UI changes or controller refactoring

## Decisions

- Retrofit client injected via `Get.find<>()` inside service
- Map REST response → existing app model in service layer
- Remove Supabase URL signing — backend returns direct URLs

## Risks / Trade-offs

- REST response field names assumed from contract — adjust `@JsonKey` if needed when testing
