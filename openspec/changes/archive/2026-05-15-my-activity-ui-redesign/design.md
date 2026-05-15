## Context

My Activity screen (`activity_view.dart`) uses `EmptyState` widget for all tabs when data is absent. Current `EmptyState` supports a single optional action button. The new design requires a stacked layout: full-width primary CTA ("Report a Problem") above a 3-column secondary action row (Share Idea / Suggest Improvement / Appreciate) — matching the home screen's action grid pattern. The `ActionCard` widget already exists and powers the home screen grid.

The Reports tab currently shows status filter chips (All / Active / Resolved / Closed) and a Sort control. Sort must be removed; filter chips stay.

## Goals / Non-Goals

**Goals:**
- Remove Sort button from Reports tab filter row
- Replace per-tab empty states with new `ActivityEmptyState` widget: illustration + headline + primary report button + 3 secondary action cards
- All 4 tabs (Reports, Ideas, Improvements, Appreciations) show the same empty state layout
- Secondary actions: Share Idea → `Routes.ideasFlow`, Suggest Improvement → `Routes.improvementsFlow`, Appreciate → `Routes.appreciationFlow`
- Primary action always: Report a Problem → `Routes.reportFlow`

**Non-Goals:**
- No "Chat with MLA Office" action in empty state
- No changes to tab structure or tab count
- No changes to how items render when data exists
- No changes to the summary stats card
- No sort feature (remove entirely, not hide)

## Decisions

**New widget vs. extending `EmptyState`**
Create a new `ActivityEmptyState` widget alongside existing `EmptyState`. Reason: the new layout (illustration + primary button + 3-col grid) is structurally different enough that extending `EmptyState` would make it messy. Existing `EmptyState` stays for other screens (e.g., Saved tab, other features).

**Reuse `ActionCard` for secondary actions**
Use existing `ActionCard` widget for the 3 secondary action tiles. Same pattern as home screen — consistent UX, no new widget needed.

**Primary button**
Use existing `PrimaryButton` widget with "Report a Problem" label and `Routes.reportFlow` nav. Full-width inside the empty state card.

**Illustration**
Reuse existing Lottie animation (`AppAssets.emptyLottie`) from current `EmptyState`. No new asset needed.

**Sort removal**
The Reports tab currently has filter chips + sort. Remove the sort `IconButton`/widget only. Keep All/Active/Resolved/Closed filter chips. If sort is wired to controller state, remove controller property too.

## Risks / Trade-offs

- [All tabs same empty state] → Primary CTA is always "Report a Problem" even on Ideas/Improvements/Appreciations tabs. Per spec this is intentional (mirrors snapshot). Secondary actions give tab-relevant entry points.
- [ActionCard `Expanded` child] → `ActionCard` uses `Expanded` for subtitle, so it must be placed inside a fixed-height container or `Row` with constrained height. Use `IntrinsicHeight` or fixed height on the row wrapper.
