## Context

`UpdatesService.getUpdates()` has a try/catch that swallows all errors and falls back to `_mockUpdates` — five hardcoded posts with Unsplash images and fake engagement numbers. The updates view already has a proper `EmptyState` widget that renders when the list is empty, and the controller already has a `loading` observable. The only missing piece is a way to surface errors to the UI so users know when a fetch failed vs. when there are genuinely no posts.

## Goals / Non-Goals

**Goals:**
- Delete `_mockUpdates` and the fallback branch entirely
- `getUpdates()` throws on failure so callers can distinguish error from empty
- `UpdatesController` exposes an `error` observable; view renders it
- Empty list → existing `EmptyState` widget ("No updates")
- Failed fetch → error message with retry button

**Non-Goals:**
- Offline/cache layer (no persistence added)
- Pagination or infinite scroll
- Changes to `getUpdate(String id)` — already throws naturally

## Decisions

**Error propagation over silent fallback**
Remove the `catch (_) {}` in `getUpdates()`. Let the exception propagate. The controller catches it, sets `error.value`, and the view reacts. Rationale: fake data is worse than a visible error; the UI layer is already reactive and handles empty/loading states.

**`RxString` error state in controller**
Add `final RxString error = ''.obs` to `UpdatesController`. Clear on successful load. Non-empty string = error state. Simple, consistent with existing `loading: RxBool` pattern in the codebase.

**No retry timer / exponential backoff**
`RefreshIndicator` + manual pull-to-refresh is enough. No automatic retry added — that's a separate concern.

## Risks / Trade-offs

- [Risk] Database table is actually empty → shows "No updates" empty state instead of fake content. **Acceptable** — this is the correct behavior.
- [Risk] Network error on first load → user sees error instead of content. → Mitigation: error widget includes a retry button that calls `loadUpdates()`.

## Migration Plan

1. Delete `_mockUpdates` block and fallback branch from `UpdatesService`
2. Add `error` observable to `UpdatesController`; set it in catch block, clear on success
3. Update updates view to show error widget when `error` is non-empty
4. Manual test: run app with no posts in DB → confirm empty state renders
5. No rollback complexity — purely subtractive change
