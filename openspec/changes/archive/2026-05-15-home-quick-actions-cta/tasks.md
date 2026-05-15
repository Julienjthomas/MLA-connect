## 1. Localization

- [x] 1.1 Add `quickActions` and eight tile strings (4 titles + 4 subtitles) to `app_en.arb` and `app_ml.arb`
- [x] 1.2 Run codegen / update `app_localizations*.dart` and expose via `AppStrings`

## 2. UI components

- [x] 2.1 Create `QuickActionTile` with horizontal layout (icon chip, title, subtitle, tap handler)
- [x] 2.2 Create `QuickActionsSection` (card chrome: border, padding, title, 2×2 grid)

## 3. Home screen integration

- [x] 3.1 Replace `_buildWhatWouldYouLike` + `_buildActionGrid` in `home_view.dart` with `QuickActionsSection`
- [x] 3.2 Wire four tiles to existing routes using `FeatureType` icons/colors and new l10n copy
- [x] 3.3 Remove or simplify viewport-budget `tileSize` / aspect-ratio logic if compact layout passes QA

## 4. Verification

- [x] 4.1 Verify EN and ML labels on all four tiles
- [x] 4.2 Verify navigation to report, idea, improve, and appreciate flows
- [x] 4.3 Verify Updates section header visible without scroll on 640px+ height (e.g. iPhone SE simulator)
