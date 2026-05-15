## Context

`ChatView` is the signed-in citizen compose and history screen for MLA office messages. It already wires `ChatController` categories (`personal`, `request`, `invitation`, `other`), message loading, send, and the unauthenticated gate. The current UI uses `AppColors.background` on the scaffold, a standard `AppBar`, centered empty copy, a bottom composer `Container` with upward shadow, Material `ChoiceChip` widgets, an outlined `TextField`, and shared `PrimaryButton`.

The approved snapshot defines a fixed visual system: white app bar, lavender history pane, white composer block, custom category pills, borderless gray message field, and a full-width purple Send pill without composer elevation.

## Goals / Non-Goals

**Goals:**
- Match the snapshot layout and styling for app bar, history area, empty state, category selector, message field, and Send action.
- Preserve existing chat behavior: category values, send validation, history rendering, loading state, and unauthenticated messaging.
- Reuse existing theme tokens (`AppColors`, `AppTextStyles`, `PrimaryButton`) where they already match; add local or shared tokens only when needed for snapshot fidelity.

**Non-Goals:**
- No changes to `OfficeMessagesService`, Supabase schema, routing, or `ChatController` business rules.
- No redesign of sent-message list cards beyond keeping them readable on the new history background.
- No new dependencies or custom SVG assets.

## Decisions

**1. Split the body into history pane and composer pane**
Use a `Column` with an `Expanded` history region on `AppColors.background` (or a dedicated chat-history token if added) and a bottom composer on `AppColors.surface` without `BoxShadow`. This mirrors the snapshot separation between lavender content and white form.

**2. Replace `ChoiceChip` with private selectable pill widgets**
Material `ChoiceChip` cannot reproduce the snapshot selected state (light purple fill, purple label, leading checkmark) and unselected state (white fill, light gray border) together. Implement small private widgets in `chat_view.dart` (or a colocated `chat_category_chip.dart` only if the file grows unwieldy) driven by `ChatController.categories` and `controller.category`.

**3. Category layout uses `Wrap` with fixed spacing**
Keep the existing two-row `Wrap` (`spacing` / `runSpacing` 8) so labels wrap naturally on narrow widths while matching the snapshot on standard phone widths.

**4. Message field uses filled `InputDecoration` without outline**
Use `TextField` with `filled: true`, `fillColor: AppColors.grey100`, `border: InputBorder.none`, `contentPadding` aligned to the snapshot, `minLines: 3`, and hint **Write your message...** via existing copy or localization if already centralized.

**5. Send uses `PrimaryButton` with pill radius override**
Keep `PrimaryButton` for loading/disabled handling. Override shape to a higher corner radius (approximately half button height) so Send reads as a pill. Do not add composer shadow.

**6. App bar stays centered-title with back affordance**
Keep `AppBar` with `backgroundColor: AppColors.surface`, `elevation: 0`, title **Chat with MLA office**, and default back navigation. No trailing actions in the snapshot.

**7. Strings stay behaviorally identical**
Retain current English copy for title, empty state, category labels, placeholder, and Send unless the project already exposes these through `AppStrings` / l10n; in that case wire the view to those accessors without changing meaning.

## Risks / Trade-offs

- [Snapshot purples differ slightly from `AppColors.primary`] → Prefer existing brand primary and nearest surface tints; only introduce new constants if side-by-side review still shows a visible mismatch.
- [Custom chips duplicate Material focus/semantics behavior] → Use `InkWell` / `Material` with explicit `selected` semantics and minimum tap targets.
- [History cards were tuned for old background] → Verify contrast for category badge and timestamp on the lavender pane; adjust card surface only if readability fails.

## Migration Plan

UI-only change. Ship in the next app release. No data migration or feature flag required. Roll back by reverting `ChatView` styling if QA finds regressions.

## Open Questions

None.
