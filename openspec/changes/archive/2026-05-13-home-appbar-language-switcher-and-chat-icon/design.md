## Context

The home screen `SliverAppBar` currently has one action: a notification bell. The bottom navigation has 5 tabs: Home, Chat, My Activity, Updates, Profile. Language switching exists via `AppLocale.change()` but has no UI entry point. `shared_preferences` is already a project dependency.

Chat is a low-frequency feature that doesn't warrant a persistent bottom nav slot. Language switching needs to be immediate and persistent, reachable from the home screen without extra navigation.

## Goals / Non-Goals

**Goals:**
- Add language switcher (EN ↔ ML toggle) as an icon button in the home app bar actions, between notification and chat
- Add chat icon button as the rightmost action in the home app bar
- Persist language choice via `SharedPreferences` so it survives app restarts
- Remove Chat from bottom nav bar; Chat becomes a standalone named route pushed from the app bar
- Adjust shell tab indices so Activity = 1, Updates = 2, Profile = 3

**Non-Goals:**
- Adding language switcher to other screens
- Redesigning the chat screen itself
- Supporting more than two locales (EN and ML)

## Decisions

**1. Language switcher as icon button, not a dropdown**
A single icon button (`language_rounded`) with a text badge showing current locale (`EN`/`ML`) is faster to tap and requires no extra overlay. Toggling between two values makes a dropdown unnecessary.

**2. Persist locale in SharedPreferences, load on app startup**
`AppLocale.change()` already calls `Get.updateLocale()` at runtime. On startup (`main.dart`) we read the stored key instead of falling back to device locale. This keeps locale logic in one place.

**3. Chat as a pushed route, not an IndexedStack tab**
Removes the Chat tab from the shell entirely. `Routes.chat` is added as a named route with `ChatBinding`. Navigation from the app bar uses `Get.toNamed(Routes.chat)`. This means chat state is not preserved when leaving — acceptable since the screen loads from Supabase on `onInit`.

**4. ShellController index adjustment**
After removing Chat (was index 1), indices shift: Activity=1, Updates=2, Profile=3. The one internal caller (`_buildUpdatesHeader` calls `goTo(3)`) needs updating to `goTo(2)`. The `ActivityController.loadActivity()` call in `ShellController.goTo()` moves to index 1.

## Risks / Trade-offs

- **Chat state lost on back navigation** → Acceptable; messages reload from Supabase on each open. If stateful chat is needed later, restore it as a shell tab.
- **SharedPreferences async on startup** → Read locale before `runApp()` in `main()` using `await`. Small startup overhead, already acceptable since Supabase init is awaited.
- **Index drift** → Any future shell tab additions must update `ShellController` and any hardcoded `goTo(n)` calls. Mitigated by keeping `goTo` calls in one place (home_view).
