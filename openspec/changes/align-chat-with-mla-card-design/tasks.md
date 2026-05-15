## 1. Update String Constants

- [x] 1.1 In `lib/l10n/app_localizations_en.dart`, update `chatWithYourMla` value to `'MLA Office Support'`
- [x] 1.2 In `lib/l10n/app_localizations_en.dart`, update `chatWithYourMlaSubtitle` value to `'Message the constituency office directly.'`
- [x] 1.3 In `lib/l10n/app_localizations_ml.dart`, update the Malayalam equivalents for both strings accordingly

## 2. Redesign `_ChatWithMlaCard` in profile_view.dart

- [x] 2.1 Change the icon container `BoxDecoration` from `borderRadius: BorderRadius.circular(12)` to `shape: BoxShape.circle`
- [x] 2.2 Replace `Icons.chat_bubble_rounded` with `Icons.account_balance_rounded` inside the icon container
- [x] 2.3 Add a light primary-tinted background to the card container: `color: AppColors.primary.withValues(alpha: 0.04)` (on the outer `Container` decoration)
- [x] 2.4 Remove the trailing `Icon(Icons.chevron_right_rounded, ...)` 
- [x] 2.5 Add an `OutlinedButton.icon` as the trailing widget with: label `'Start Chat'`, icon `Icons.chat_bubble_outline_rounded`, `foregroundColor: AppColors.primary`, `side: BorderSide(color: AppColors.primary)`, `shape: StadiumBorder()`, `onPressed: () => Get.toNamed(Routes.chat)`
- [x] 2.6 Verify the full-card `InkWell` / `onTap: () => Get.toNamed(Routes.chat)` is still present and functional
