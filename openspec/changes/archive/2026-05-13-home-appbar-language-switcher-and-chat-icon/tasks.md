## 1. Add Chat as Named Route

- [x] 1.1 Add `static const chat = '/chat'` to `Routes` in `lib/routes/app_routes.dart`
- [x] 1.2 Add `GetPage` for `Routes.chat` in `lib/routes/app_pages.dart` with `ChatView` and a `ChatBinding` (create `lib/features/chat/bindings/chat_binding.dart` if it doesn't exist)

## 2. Persist and Load Locale

- [x] 2.1 Update `AppLocale.change()` in `lib/core/utils/app_locale.dart` to also write the locale code to SharedPreferences under key `app_locale`
- [x] 2.2 Add a static `AppLocale.load()` async method that reads the stored key from SharedPreferences and returns the locale string (defaulting to `'en'`)
- [x] 2.3 In `main()` in `lib/main.dart`, call `await AppLocale.load()` and use the result to set the initial locale instead of checking device locale

## 3. Home App Bar Actions

- [x] 3.1 In `home_view.dart` `_buildAppBar()`, add a language toggle `IconButton` (or `TextButton`) after the notification stack — shows `ML` when locale is `en`, `EN` when locale is `ml` — wraps in `Obx` to react to locale changes
- [x] 3.2 Add chat `IconButton` (icon: `Icons.chat_bubble_outline_rounded`) as the final action, calls `Get.toNamed(Routes.chat)` on tap
- [x] 3.3 Remove the trailing `SizedBox(width: 8)` spacer if needed to keep actions tight

## 4. Remove Chat from Shell

- [x] 4.1 In `main_shell_view.dart`, remove `ChatView()` from the `IndexedStack` children list
- [x] 4.2 Remove the Chat `NavigationDestination` from the `NavigationBar` destinations list
- [x] 4.3 Remove the `ChatView` import from `main_shell_view.dart`

## 5. Fix Shell Index References

- [x] 5.1 In `shell_controller.dart`, update `goTo()` so `ActivityController.loadActivity()` is triggered at index `1` (was `2`)
- [x] 5.2 In `home_view.dart` `_buildUpdatesHeader()`, update `goTo(3)` to `goTo(2)` to point at the Updates tab

## 6. Verify

- [x] 6.1 Run `flutter analyze` — zero errors
- [x] 6.2 Hot-reload and verify: notification icon → language toggle (EN/ML) → chat icon all appear in the app bar
- [x] 6.3 Tap language toggle: app switches language; restart app and confirm language persists
- [x] 6.4 Tap chat icon: ChatView opens as a pushed route; back button returns to home
- [x] 6.5 Verify bottom nav has exactly 4 tabs: Home, My Activity, Updates, Profile — no Chat tab
- [x] 6.6 Tap "View All" on home updates section: shell switches to Updates tab (index 2)
- [x] 6.7 Tap My Activity tab: activity data loads correctly
