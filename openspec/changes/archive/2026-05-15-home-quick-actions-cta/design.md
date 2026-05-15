## Context

`HomeView` renders four engagement CTAs via `ActionCard` in a `SliverGrid` below the heading `AppStrings.whatWouldYouLike` (“What would you like to share today?”). Cards stack icon above text, use long titles (“Report Problem”, “Share Idea”), and color titles with each `FeatureType` accent. Grid height uses viewport-budget math from `responsive-action-grid` so MLA Activity stays on screen.

The target UI (design snapshot) is a single **Quick actions** card: white surface, light border, 16px padding, 2×2 grid of **horizontal** tiles on `AppColors.surfaceAlt` with icon chip + two-line text.

## Goals / Non-Goals

**Goals:**

- Match snapshot layout: section card, horizontal tiles, short EN/ML copy, icon accent backgrounds.
- Keep existing `Get.toNamed` routes for all four actions.
- Keep MLA Activity header visible on first paint for phones ≥ 640px tall (existing product constraint).

**Non-Goals:**

- Changing submission flows, icons in other screens, or `FeatureType` labels used outside home.
- New analytics events or backend work.
- Redesigning hero banner, updates feed, or bottom navigation.

## Decisions

### 1. New widget `QuickActionTile` (extend `ActionCard` layout mode)

**Choice:** Add a dedicated `QuickActionTile` in `lib/features/home/widgets/` (or evolve `ActionCard` with `ActionCardLayout.horizontal`).

**Rationale:** Horizontal layout differs materially (Row vs Column, title color, background). A small focused widget avoids breaking other `ActionCard` consumers.

**Alternative:** Replace `ActionCard` entirely — rejected; may be used elsewhere and vertical layout is still valid elsewhere.

### 2. Section wrapper `QuickActionsSection`

**Choice:** One `Container`/`DecoratedBox` in `home_view.dart` (or extracted widget) with:

- Title: l10n `quickActions`
- `border: Border.all(AppColors.border)` (or existing divider token)
- `borderRadius: 16`, `color: AppColors.surface`
- Inner `GridView` or fixed-height `SliverGrid` with `crossAxisCount: 2`, spacing 12

**Rationale:** Snapshot shows one card containing header + grid, not a floating section title.

### 3. Copy via l10n, not `FeatureType.label`

**Choice:** New keys: `quickActions`, `quickActionIssue`, `quickActionIssueSubtitle`, etc. (4× title + 4× subtitle).

**Rationale:** Home copy is shorter than flow titles; `FeatureType` strings stay for forms and activity lists.

**Mapping:**

| Tile | Route | Icon / color |
|------|--------|----------------|
| Issue | `Routes.reportFlow` | `FeatureType.report` |
| Idea | `Routes.ideasFlow` | `FeatureType.idea` |
| Suggest | `Routes.improvementsFlow` | `FeatureType.improve` |
| Appreciate | `Routes.appreciationFlow` | `FeatureType.appreciate` |

Order in grid: Issue, Idea, Suggest, Appreciate (matches snapshot reading order).

### 4. Grid sizing: content-driven with max height cap

**Choice:** Drop dynamic `tileSize` / aspect-ratio hack if horizontal tiles have stable ~72–88px row height; use `mainAxisExtent` or intrinsic height with `max` clamp so total section height ≈ 200–220px.

**Rationale:** Horizontal tiles are shorter; fixed row height is simpler and still satisfies viewport budget.

**Alternative:** Keep full viewport-budget formula — only if testing shows MLA Activity clipped on iPhone SE.

### 5. Styling tokens

- Tile background: `AppColors.surfaceAlt` (or nearest existing gray surface)
- Title: `AppTextStyles.titleMedium` + `AppColors.textPrimary` (not accent)
- Subtitle: `AppTextStyles.caption` + `AppColors.textSecondary`
- Icon chip: `accentColor.withValues(alpha: 0.12)`, 10px radius, icon from `FeatureType`

## Risks / Trade-offs

- **[Risk] Malayalam strings longer than EN** → Use `maxLines: 1` + ellipsis on title; subtitle `maxLines: 2`.
- **[Risk] Removing viewport math regresses small screens** → Verify on 640px height simulator; reintroduce clamp only if MLA Activity header scrolls off.
- **[Risk] Duplicate widget APIs** → Document that home uses `QuickActionTile`; keep `ActionCard` for other screens until consolidated.

## Migration Plan

1. Implement widget + l10n.
2. Swap `home_view` section; remove `_buildWhatWouldYouLike` or merge into quick actions card.
3. Manual QA on small/medium/large phones.
4. No feature flag; ship with next app release.

## Open Questions

- None blocking — snapshot is authoritative for layout and copy.
