## Why

The current ChatView uses a generic form-based layout with no visual polish. The redesigned UI replaces it with a modern messaging interface — empty state illustration, a floating input bar, and a send button — improving perceived quality and usability.

## What Changes

- Replace plain "no messages" text with a centered illustration + headline + subtitle empty state
- Replace the bottom form container (category chips + multi-line TextField + PrimaryButton) with a single-line floating input bar containing an attachment icon and a circular send FAB
- Update AppBar to show back arrow on left and info icon on right (matching snapshot)
- Keep all existing controller logic (send, load, category) intact — UI-only change
- Message list bubbles remain; only the input area and empty state change

## Capabilities

### New Capabilities
- `chat-view-redesign`: Visual redesign of ChatView — empty state, floating input bar, send FAB, updated AppBar actions

### Modified Capabilities
- `mla-office-chat`: Input interaction model changes (single-line bar replaces multi-line form with category chips)

## Impact

- `lib/features/chat/views/chat_view.dart` — full rewrite of UI layer
- No controller changes required
- Uses existing `AppColors.primary`, `AppColors.background`, `AppColors.surfaceVariant`
