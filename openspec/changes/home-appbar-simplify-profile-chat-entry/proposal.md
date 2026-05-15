## Why

The home app bar is crowded with language and chat actions that compete with constituency identity and notifications. Moving chat and language to profile-aligned entry points keeps the home header focused while preserving access where users manage account and communication settings.

## What Changes

- **BREAKING**: Remove the language switcher and chat shortcut from the home app bar.
- Simplify the home app bar to show the active constituency name and a notification action only.
- Add a prominent **Chat with your MLA** entry on the Profile tab, placed above the Notifications section.
- Keep language selection on the Profile tab in General settings (existing Language tile).

## Capabilities

### New Capabilities

- None.

### Modified Capabilities

- `home-appbar-language-switcher`: Language control is no longer on the home app bar; home remains constituency + notifications only.
- `home-appbar-chat-shortcut`: Chat is no longer launched from the home app bar; Profile provides the primary chat entry above notifications.
- `profile-settings`: Profile adds a chat-with-MLA entry above notification preference switches.

## Impact

- `lib/features/home/views/home_view.dart` — app bar actions and title layout.
- `lib/features/profile/views/profile_view.dart` — new chat entry section.
- Localization strings for the profile chat entry label and subtitle.
- OpenSpec deltas for home app bar and profile settings capabilities.
