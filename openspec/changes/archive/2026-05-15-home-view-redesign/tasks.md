## 1. Strings & Localisation

- [x] 1.1 Add new string keys to `lib/core/constants/app_strings.dart`: app tagline ("Your voice. Our priority."), community banner headline, community banner subtext, quick actions section header ("What would you like to do?"), updated quick action subtitles (Request Help / Appreciate Work), community impact section header and chip labels, FAB label ("Raise New Issue")
- [x] 1.2 Add corresponding keys to `lib/l10n/app_en.arb` and `lib/l10n/app_ml.arb`
- [x] 1.3 Regenerate localization files (`lib/l10n/app_localizations.dart`, `app_localizations_en.dart`, `app_localizations_ml.dart`)

## 2. AppBar Update

- [x] 2.1 Update `_buildAppBar()` in `home_view.dart`: replace rocket icon container with app name + "Your voice. Our priority." tagline text
- [x] 2.2 Add user profile avatar (circle, 36dp) on the right side of the AppBar using `AuthController.user.value?.photoUrl`; fallback to person icon

## 3. MLA Hero Card Widget

- [x] 3.1 Create `lib/features/home/widgets/mla_hero_card.dart`: full card widget with white background, rounded corners, MLA photo (large, ~100dp, left), "Your MLA" label + name + constituency (right), and three contact action buttons (Contact Office, Message MLA, Meet MLA) in a row below
- [x] 3.2 Wire Contact Office button: use `url_launcher` to launch `tel:` with `mla.contact.phone`
- [x] 3.3 Wire Message MLA button: navigate to MLA office chat route (use existing route or `Routes.mlaDetail` as fallback)
- [x] 3.4 Wire Meet MLA button: navigate to `Routes.mlaDetail`
- [x] 3.5 Replace `MlaHeroBanner` usage in `home_view.dart` `_buildHeroBanner()` with `MlaHeroCard`

## 4. Community Hero Banner Widget

- [ ] 4.1 Create `lib/features/home/widgets/community_hero_banner.dart`: purple gradient container, bold headline, subtext, stats row at bottom (Active Issues / In Progress / Resolved) using `MlaStats`
- [ ] 4.2 Map stats: Active Issues → `stats.activeProjects`, In Progress → `0` placeholder, Resolved → `stats.issuesResolved`
- [ ] 4.3 Add `CommunityHeroBanner` sliver to `home_view.dart` between MLA hero card and quick actions section

## 5. Quick Actions Redesign

- [ ] 5.1 Update `QuickActionTile` in `quick_action_tile.dart` to support vertical card layout: icon centered at top in a colored circle badge, title below, subtitle below title, small `chevron_right` arrow at bottom; increase tile height to ~130dp
- [ ] 5.2 Update `QuickActionsSection` in `quick_actions_section.dart`: change header text to use new `AppStrings.whatWouldYouLikeToDo` string; update tile row height constant to 130dp
- [ ] 5.3 Update tile labels/subtitles in `QuickActionsSection`: "Report Issue" / "Share Idea" / "Request Help" / "Appreciate Work" with matching subtitles from new string keys

## 6. Recent Updates Status Badge

- [ ] 6.1 Add status badge overlay to `_activityCard()` in `home_view.dart`: use a `Stack` to overlay a colored chip on thumbnail top-left; derive label/color from `UpdateModel.category` (map to In Progress / Resolved / New) or default to "New"

## 7. Community Impact Section

- [ ] 7.1 Add `_buildCommunityImpact()` method to `home_view.dart`: section with "Community Impact" header, tagline, and a `Row` of three stat chips (Issues Resolved / Ideas Implemented / Appreciations Shared) from `MlaStats`
- [ ] 7.2 Insert community impact sliver into the scroll view after recent updates section

## 8. Raise New Issue Button

- [ ] 8.1 Add `_buildRaiseIssueFab()` sliver to bottom of `home_view.dart`: full-width purple `ElevatedButton` with "+" icon and "Raise New Issue" label; bottom padding clears shell nav bar (~80dp)
- [ ] 8.2 Wire button to `Get.toNamed(Routes.reportFlow)`
