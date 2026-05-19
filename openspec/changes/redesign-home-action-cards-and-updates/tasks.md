## 1. Assets

- [x] 1.1 Add 4 background illustration images to `assets/images/` — one per feature: `card_report.png`, `card_idea.png`, `card_improve.png`, `card_appreciate.png` (use placeholder images if final illustrations not ready)
- [x] 1.2 Register all 4 image paths under `flutter > assets` in `pubspec.yaml`

## 2. FeatureType Extension

- [x] 2.1 Add `String get backgroundImage` getter to `FeatureTypeX` in `lib/core/constants/app_enums.dart`, returning the correct asset path per type

## 3. ActionCard Widget Redesign

- [x] 3.1 Add optional `String? backgroundImage` parameter to `ActionCard` constructor
- [x] 3.2 Wrap card content in a `Stack` — background image fills lower ~40% of card using `Positioned.fill` + `Align(alignment: Alignment.bottomCenter)`
- [x] 3.3 Add gradient overlay (`LinearGradient`, transparent → accent light color) on top of background image to ensure text readability
- [x] 3.4 Change icon container to use a circular shape (full border radius) with accent color at 15% opacity
- [x] 3.5 Add 24×3px accent-colored underline bar directly below the title `Text` widget
- [x] 3.6 Add circular white arrow CTA button (`CircleAvatar` + `Icon(Icons.arrow_forward_rounded)`) positioned bottom-right over the image zone
- [x] 3.7 Ensure `onTap` is wired to the full card `GestureDetector` AND the arrow button

## 4. Home View — Action Grid

- [x] 4.1 Pass `backgroundImage: FeatureType.report.backgroundImage` (and equivalent for each type) to each `ActionCard` in `_buildActionGrid`

## 5. Home View — Updates Section

- [x] 5.1 Add `recentUpdates` string to `AppStrings` (value: `"Recent Updates"`) and use it in `_buildUpdatesHeader` section header title
- [x] 5.2 Increase updates feed `SizedBox` height from `200` to `240` in `_buildUpdatesFeed`
- [x] 5.3 Refactor `_activityCard` signature to accept `UpdateModel item` and `double width` instead of decomposed strings
- [x] 5.4 Add metadata row inside `_activityCard`: calendar icon + formatted date (`DateFormat('MMM d, yyyy').format(item.createdAt)`), eye icon + `item.views`, heart icon + `item.likes` — all in a single `Row` with `spacing` and `TextStyle` matching `AppTextStyles.caption`
- [x] 5.5 Update the `itemBuilder` in `_buildUpdatesFeed` to pass the full `UpdateModel` to the refactored `_activityCard`
- [x] 5.6 Add `intl` package import (already available via Flutter SDK) for `DateFormat` or use manual date formatting via `DateFormatter` util if already present
