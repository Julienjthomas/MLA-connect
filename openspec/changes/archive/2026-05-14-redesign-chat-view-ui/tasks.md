## 1. AppBar

- [x] 1.1 Add `actions: [IconButton(icon: Icon(Icons.info_outline), onPressed: null)]` to AppBar in `chat_view.dart`

## 2. Background color

- [x] 2.1 Set `Scaffold.backgroundColor` to `AppColors.surfaceVariant` (lavender `#F5F3FF`)

## 3. Empty state widget

- [x] 3.1 Create private `_EmptyState` widget (or method) in `chat_view.dart` with the chat-bubble illustration drawn using nested `Container` + `BoxDecoration`
- [x] 3.2 Add decoration dots/sparkles around the bubble using positioned small `Container` circles
- [x] 3.3 Add "Start a conversation" `Text` in bold `titleLarge` style below illustration
- [x] 3.4 Add subtitle `Text` "Send a message to the MLA office.\nWe'll get back to you soon." in `bodyMedium` with `textSecondary` color, center-aligned
- [x] 3.5 Replace existing "No messages yet" text block with `_EmptyState()` in the `controller.items.isEmpty` branch

## 4. Floating pill input bar

- [x] 4.1 Remove category `Wrap`/`ChoiceChip` section from bottom container
- [x] 4.2 Remove multi-line `TextField` and `PrimaryButton` from bottom container
- [x] 4.3 Replace bottom container with a transparent `SafeArea` wrapper containing a `Row`
- [x] 4.4 Inside the row: white pill `Container` (`borderRadius: 30`, soft shadow) with `Expanded` single-line `TextField` (no border decoration, hint "Type your message…") and paperclip `IconButton(icon: Icon(Icons.attach_file_outlined))`
- [x] 4.5 Add circular send `InkWell`/`GestureDetector` container (48×48, `AppColors.primary` fill, paper-plane icon in white) as second child of the row, with `onTap: controller.sending.value ? null : controller.send`
- [x] 4.6 Wrap send button in `Obx` to reactively disable while `controller.sending.value` is true

## 5. Verify

- [ ] 5.1 Hot-reload and confirm empty state matches snapshot on a clean session
- [ ] 5.2 Type a message, tap send — confirm message appears in list and input clears
- [ ] 5.3 Confirm loading spinner still shows while `controller.loading.value` is true
- [ ] 5.4 Confirm unauthenticated state still shows sign-in prompt (no regression)
