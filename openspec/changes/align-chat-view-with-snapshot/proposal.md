## Why

The MLA office Chat screen still uses generic Material controls (default `ChoiceChip`, outlined `TextField`, and a composer panel with drop shadow) that do not match the approved citizen-app snapshot. Citizens should see the same white app bar, lavender message area, category chips, message field, and full-width Send control as in design so the channel feels official and consistent with the rest of the app.

## What Changes

- Restyle the Chat screen app bar to a white surface with centered title **Chat with MLA office** and a standard back affordance.
- Give the message history region a light lavender/off-white background distinct from the white composer.
- Show the signed-in empty state as centered two-line copy: **No messages yet.** and **Use the form below to send your first message.**
- Replace default category chips with snapshot-aligned selectable pills: **Personal message**, **Request**, **Invitation**, and **Other**, with selected state (light purple fill, purple label, leading checkmark) and unselected state (white fill, light gray border, dark gray label).
- Restyle the message body field as a large rounded light-gray text area with placeholder **Write your message...** and no visible outline border.
- Restyle Send as a full-width pill-shaped primary button labeled **Send** with no elevation shadow on the composer panel.
- Keep existing send, category, history, and unauthenticated-gate behavior unchanged.

## Capabilities

### New Capabilities

<!-- none -->

### Modified Capabilities

- `mla-office-chat`: Add and tighten visual/layout requirements for the Chat screen shell, empty state, category selector, message field, and send action so they match the approved snapshot.

## Impact

- `lib/features/chat/views/chat_view.dart` — primary layout and styling updates
- `lib/core/theme/app_colors.dart` and/or `lib/core/theme/app_text_styles.dart` — only if new shared tokens are needed for snapshot-exact colors and radii
- `lib/l10n/` — only if user-visible Chat strings are centralized or localized instead of inline literals
- No API, routing, controller, or persistence changes expected
