## Context

`ChatView` is a single file (`lib/features/chat/views/chat_view.dart`) with no sub-widgets. The controller (`ChatController`) owns all state. This is a pure UI-layer change — no data model or service changes.

## Goals / Non-Goals

**Goals:**
- Match the snapshot: lavender `#F0EEFF` background, centered chat-bubble illustration + "Start a conversation" empty state, floating pill input bar with paperclip icon, circular purple send FAB
- Updated AppBar: back arrow left, title centered, info (ⓘ) icon right
- Keep all existing send/load logic untouched

**Non-Goals:**
- Category chip selection (removed from input area in new design — deferred or hidden)
- Attachment functionality (paperclip icon renders but is no-op for now)
- Bubble-style message list redesign (existing card list retained)

## Decisions

### 1. Inline widget extraction vs separate files
Rewrite `chat_view.dart` in-place with private helper methods/widgets (`_EmptyState`, `_InputBar`). No new files — the feature is self-contained and small.

**Why:** Avoids file proliferation for a single-screen change. Private helpers are enough at this scale.

### 2. Empty state illustration via Flutter widgets (no asset)
Draw the chat bubble using nested `Container` + `BoxDecoration` with `BorderRadius` and decoration dots — no SVG/PNG asset needed.

**Why:** Snapshot uses a simple geometric illustration. Code-drawn avoids asset pipeline friction. Can be swapped for an asset later with no API change.

### 3. Input bar layout
`Row` inside a `Container` with `borderRadius: 30`, white background, subtle shadow. Left: `TextField` (single line, no border). Middle: paperclip `IconButton`. Right: circular `FloatingActionButton`-style send button outside the pill (matches snapshot).

**Why:** Snapshot shows the send button as a separate circle partially overlapping the pill — implemented as a `Row` with the FAB as a sibling, not inside the pill container.

### 4. Category selection
Remove from bottom bar. The controller still holds `category` state defaulting to `'personal'`. All sends use the default. Can be re-exposed via a sheet or menu later.

**Why:** Snapshot shows no category UI. Keeping controller state avoids breaking the send path.

## Risks / Trade-offs

- Removing category chips is a feature regression → Mitigated by defaulting to `'personal'`; low impact since most users send personal messages
- Code-drawn illustration is fragile to spacing changes → Mitigated by using fixed sizes matching the snapshot proportions
