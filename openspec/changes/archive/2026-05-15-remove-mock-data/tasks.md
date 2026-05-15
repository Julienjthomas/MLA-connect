## 1. Remove Mock Data from UpdatesService

- [x] 1.1 Delete the `_mockUpdates` static field (lines 145–180 in `lib/data/services/updates_service.dart`)
- [x] 1.2 Rewrite `getUpdates()`: remove the outer try/catch fallback — let errors propagate. Keep inner try/catch only for non-critical helpers (`_attachPostMedia`, `_signCoverImages`, `_signAttachmentPaths`) which already handle their own failures silently
- [x] 1.3 Verify `getUpdates()` returns an empty list when the query succeeds but returns no rows (not a throw — just empty)

## 2. Add Error State to UpdatesController

- [x] 2.1 Add `final RxString error = ''.obs;` field to `UpdatesController`
- [x] 2.2 In `loadUpdates()`, clear `error.value = ''` before the fetch attempt
- [x] 2.3 In the catch block, set `error.value = 'Could not load updates. Please try again.'` instead of silently clearing `likedIds`
- [x] 2.4 On success, ensure `error.value` stays cleared

## 3. Update UpdatesView to Show Error State

- [x] 3.1 In `updates_view.dart`, add an `else if (controller.error.isNotEmpty)` branch in the Obx builder (after loading check, before empty/list)
- [x] 3.2 Render an error widget with the error message text and a `TextButton('Retry', onPressed: controller.loadUpdates)` — use existing `AppTextStyles` and `AppColors`
- [x] 3.3 Confirm existing empty-state branch (`items.isEmpty` → `EmptyState(...)`) still renders correctly for zero-result success case

## 4. Verify

- [x] 4.1 Run `flutter analyze` — no new errors or warnings
- [ ] 4.2 Manually test: launch app with posts in DB → list renders
- [ ] 4.3 Manually test: launch app with empty posts table → EmptyState renders
