## Why

The `_ChatWithMlaCard` in the profile screen uses a generic chat-bubble icon in a rounded square and a plain chevron — lacking the official, institutional feel the MLA Office channel deserves. The new design (confirmed snapshot) gives the card a circular capitol-building icon badge and a labelled "Start Chat" outlined button, making the entry point clearer and visually aligned with the app's brand identity for MLA-related surfaces.

## What Changes

- Replace the square chat-bubble icon container with a circular container using `account_balance_rounded` (or equivalent capitol icon) in primary purple
- Replace the trailing `chevron_right` with an outlined "Start Chat" button (rounded rectangle, primary-colored border/text, chat-bubble-outline icon)
- Update card background tint to use a very light primary-tinted surface (`primary.withValues(alpha: 0.04)`) matching the snapshot's lavender wash
- Keep `onTap` navigation to `Routes.chat` (whole card stays tappable)
- String constants `chatWithYourMla` / `chatWithYourMlaSubtitle` may be updated to match "MLA Office Support" / "Message the constituency office directly."

## Capabilities

### New Capabilities
<!-- none -->

### Modified Capabilities
- `mla-office-chat`: Visual design of the chat entry-point card changes; no behavioral requirement changes, UI-only delta

## Impact

- `lib/features/profile/views/profile_view.dart` — `_ChatWithMlaCard` widget redesign
- `lib/core/constants/app_strings.dart` — string constant values (if updated)
- `lib/l10n/` — localization strings if titles change
