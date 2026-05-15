## 1. Remove Sort Control

- [x] 1.1 In `activity_view.dart`, locate the Reports tab filter row widget and remove the Sort button/icon entirely
- [x] 1.2 Remove any sort-related state or methods from `ActivityController` that are no longer used after sort removal

## 2. Create ActivityEmptyState Widget

- [x] 2.1 Create `lib/core/widgets/activity_empty_state.dart` with a new `ActivityEmptyState` stateless widget
- [x] 2.2 Widget layout: Lottie illustration (reuse `AppAssets.emptyLottie`) → headline text → full-width `PrimaryButton` ("Report a Problem") → 16px gap → `IntrinsicHeight` row of 3 `ActionCard` tiles
- [x] 2.3 Wire primary button: `onTap` navigates to `Routes.reportFlow` via `Get.toNamed`
- [x] 2.4 Add Share Idea `ActionCard` tile: icon `Icons.lightbulb_outline`, accent `AppColors.ideaPurple`, taps → `Routes.ideasFlow`
- [x] 2.5 Add Suggest Improvement `ActionCard` tile: icon `Icons.tips_and_updates_outlined`, accent `AppColors.improveBlue`, taps → `Routes.improvementsFlow`
- [x] 2.6 Add Appreciate `ActionCard` tile: icon `Icons.favorite_outline`, accent `AppColors.appreciateGreen`, taps → `Routes.appreciationFlow`
- [x] 2.7 Ensure no chat action is present in the widget

## 3. Replace Empty States in Activity View

- [x] 3.1 In `activity_view.dart`, import `ActivityEmptyState`
- [x] 3.2 Replace `EmptyState(...)` in `_ReportsTab` with `ActivityEmptyState()`
- [x] 3.3 Replace `EmptyState(...)` in `_IdeasTab` with `ActivityEmptyState()`
- [x] 3.4 Replace `EmptyState(...)` in `_ImprovementsTab` with `ActivityEmptyState()`
- [x] 3.5 Replace `EmptyState(...)` in `_AppreciationsTab` with `ActivityEmptyState()`

## 4. Verification

- [x] 4.1 Run `flutter analyze` — zero new errors or warnings
- [ ] 4.2 Hot-reload and manually verify Reports tab empty state shows correct layout (illustration + primary button + 3 action cards)
- [ ] 4.3 Verify no Sort button appears anywhere on the Reports tab
- [ ] 4.4 Verify tapping each action card navigates to the correct flow
