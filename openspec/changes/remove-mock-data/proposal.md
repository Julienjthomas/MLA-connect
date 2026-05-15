## Why

The app ships hardcoded mock data in `UpdatesService` that silently falls back to fake Unsplash posts whenever the database is empty or unreachable. This masks real data-layer failures, misleads users with fabricated content, and must be removed before production.

## What Changes

- Remove `_mockUpdates` static list and all fallback logic from `UpdatesService`
- `getUpdates()` returns an empty list (not fake data) when Supabase returns nothing
- Surface real errors instead of swallowing them silently
- Empty-state UI already exists and will correctly render when list is empty

## Capabilities

### New Capabilities

- `updates-feed-empty-state`: Proper empty/error state handling in the updates feed — real errors bubble up, empty results show existing empty-state widget, no fake fallback content

### Modified Capabilities

- `updates-feed`: Remove mock fallback path; `getUpdates()` now propagates errors rather than catching and returning fabricated data

## Impact

- `lib/data/services/updates_service.dart` — remove `_mockUpdates`, rewrite error handling in `getUpdates()`
- `lib/features/updates/controllers/updates_controller.dart` — handle error state from service (currently assumes success)
- `lib/core/widgets/activity_empty_state.dart` — verify existing empty state covers updates tab
