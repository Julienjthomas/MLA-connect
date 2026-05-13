## Why

The home screen app bar currently only shows a notification icon. Users need quick access to language switching (EN/ML) and chat without hunting through menus or the bottom nav bar. Chat in the bottom nav wastes a slot that could be reserved for higher-frequency destinations.

## What Changes

- Add language switcher icon button to the home screen app bar (after notification icon)
- Add chat icon button to the home screen app bar (after language switcher)
- Remove Chat from the bottom navigation bar
- Chat is accessible only via the app bar icon on the home screen (navigates to ChatView as a full route, not a shell tab)
- Language switcher toggles between English (`en`) and Malayalam (`ml`) and persists the selection

## Capabilities

### New Capabilities

- `home-appbar-language-switcher`: Icon button in the home app bar that toggles app language between English and Malayalam, persisting the selection via SharedPreferences and updating the app locale via `AppLocale.change()`
- `home-appbar-chat-shortcut`: Icon button in the home app bar that navigates to the Chat screen as a pushed route (not a bottom nav tab)

### Modified Capabilities

- `shell-navigation`: Remove Chat tab from bottom navigation bar and from the IndexedStack; adjust tab indices accordingly

## Impact

- `lib/features/home/views/home_view.dart` — add two icon buttons to `_buildAppBar()` actions
- `lib/features/shell/views/main_shell_view.dart` — remove Chat destination and ChatView from shell
- `lib/core/utils/app_locale.dart` — add persistence via SharedPreferences
- `pubspec.yaml` — ensure `shared_preferences` dependency is present
- `lib/routes/app_routes.dart` / `lib/routes/app_pages.dart` — ensure `/chat` is a standalone named route
