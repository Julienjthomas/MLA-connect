## Why

`MlaModel` still carries legacy field aliases and the app falls back to a hardcoded `placeholder` when live data is unavailable, meaning users may see fake MLA data. The `mlas` table schema is now stable — the model and service need to align to it cleanly.

## What Changes

- Remove legacy field aliases (`json['name']`, `json['term']`) from `MlaModel.fromJson` — only read canonical column names from `mlas`
- Remove `cover_image_url` and `serving_since` fields that are in the DB schema but not yet mapped in the model
- Map `cover_image_url` → `MlaModel.coverImageUrl` for hero banner use
- Map `serving_since` → `MlaModel.servingSince` for display
- Remove hardcoded `placeholder` usage in loading states — show shimmer/skeleton instead
- `MlaService.getMlaProfile` already fetches from Supabase correctly; clean up and align with final schema
- Stats (`issuesResolved`, etc.) remain sourced from `v_mla_stats` view — no change
- `MlaInitiative` list remains empty until an initiatives table exists (remove hardcoded list from placeholder)

## Capabilities

### New Capabilities
- `mla-data-binding`: Clean mapping of `mlas` table columns → `MlaModel` fields, with new `coverImageUrl` and `servingSince` fields exposed to UI

### Modified Capabilities
- `mla-layer`: `MlaModel.fromJson` field mapping updated to match final `mlas` schema (removing legacy aliases, adding new columns)

## Impact

- `lib/data/models/mla_model.dart` — field additions, alias removals, placeholder cleanup
- `lib/data/services/mla_service.dart` — minor cleanup, ensure `select()` includes `cover_image_url`, `serving_since`
- `lib/features/home/widgets/mla_hero_banner.dart` — can optionally consume `coverImageUrl` if wired
- No API changes, no breaking changes to callers (all fields remain accessible)
