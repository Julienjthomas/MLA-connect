## 1. Update ActionCard for responsive tile sizing

- [x] 1.1 Add optional `tileSize` parameter to `ActionCard` constructor in `lib/core/widgets/action_card.dart`
- [x] 1.2 Inside `ActionCard.build()`, derive `iconSize` and `iconPadding` from `tileSize` when provided: `iconSize = tileSize <= 90 ? 18.0 : 24.0`, `iconPadding = tileSize <= 90 ? 8.0 : 10.0`
- [x] 1.3 Apply derived values to the Icon widget and its container padding, falling back to current fixed values when `tileSize` is null

## 2. Update home action grid height calculation

- [x] 2.1 In `lib/features/home/views/home_view.dart` `_buildActionGrid()`, replace the `screenHeight * 0.30` percentage with a budget-based formula: `gridHeight = (screenHeight - 430).clamp(160.0, 240.0)`
- [x] 2.2 Recalculate `tileSize` as `(gridHeight - 12) / 2` (2 rows, 12px spacing) and pass it to each `ActionCard` as the `tileSize` argument
- [x] 2.3 Recalculate `aspectRatio` using the new `tileSize`: `aspectRatio = ((screenWidth - 44) / 2) / tileSize` (remove the `/2.8` divisor — use full half-width per column)

## 3. Verify layout across device sizes

- [ ] 3.1 Run the app on a small simulator (iPhone SE 2nd gen, 375×667pt) and confirm MLA Activity section header is visible without scrolling
- [ ] 3.2 Run on a medium simulator (iPhone 14, 390×844pt) and confirm MLA Activity section header is visible without scrolling
- [ ] 3.3 Run on a large simulator (iPhone 14 Pro Max, 430×932pt) and confirm cards look proportional and not oversized
- [ ] 3.4 Confirm all 4 action cards render correctly (no text truncation, no icon clipping) on all three sizes

