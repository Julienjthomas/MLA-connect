## 1. Chat shell and history region

- [x] 1.1 Restructure `ChatView` so the history area and composer are separate panes with snapshot backgrounds (lavender history, white composer, no composer shadow)
- [x] 1.2 Keep the white app bar with centered title **Chat with MLA office** and default back navigation
- [x] 1.3 Render the signed-in empty state as centered two-line copy matching the snapshot wording

## 2. Category selector

- [x] 2.1 Replace Material `ChoiceChip` usage with custom selectable category pills wired to `ChatController.categories` and `controller.category`
- [x] 2.2 Implement selected styling (light purple fill, purple label, leading checkmark) and unselected styling (white fill, light gray border, dark gray label)
- [x] 2.3 Preserve default selection **Personal message** and existing category keys used on send

## 3. Message field and Send action

- [x] 3.1 Restyle the message `TextField` with light gray fill, rounded corners, no outline border, and placeholder **Write your message...**
- [x] 3.2 Restyle Send as a full-width pill-shaped `PrimaryButton` with primary purple fill and white label text
- [x] 3.3 Keep send loading/disabled behavior and draft retention unchanged

## 4. Verification

- [x] 4.1 Compare the signed-in empty Chat screen side by side with the approved snapshot on a standard phone width
- [x] 4.2 Verify category selection, send success/failure, loading state, unauthenticated gate, and populated history still behave as before
