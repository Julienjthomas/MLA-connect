## Context

Home currently shows constituency branding, notifications, language toggle, and chat in one app bar. Profile already exposes language under General and notification toggles in a dedicated section. Users asked to declutter home and surface MLA chat from profile instead.

## Goals / Non-Goals

**Goals:**

- Home app bar shows only constituency title and notification affordance.
- Profile exposes a clear, tappable **Chat with your MLA** row above Notifications.
- Chat navigation continues to use `Routes.chat` with existing `ChatController` behavior.
- Language changes remain available from Profile → Language.

**Non-Goals:**

- Removing the Chat tab from the bottom shell.
- Redesigning the chat screen or notification center.
- Changing notification preference persistence.

## Decisions

1. **Home title** — Show a single primary line with the constituency name (fallback app name); drop the secondary “MLA Connect” subtitle in the app bar to reduce noise. Keep the small brand icon for visual anchor.
2. **Home actions** — Only the notification icon with unread badge placeholder remains in `actions`.
3. **Profile chat placement** — Insert a full-width surface card between the user card and Notifications section label: leading chat icon, title, one-line subtitle, chevron; tap pushes `Routes.chat`.
4. **Language** — No new home control; existing Profile Language tile unchanged.

## Risks / Trade-offs

- **[Risk] Users expect chat on home** → Chat tab and profile entry remain; home is intentionally simplified.
- **[Risk] Language discoverability** → Profile Language tile stays in General with current value shown.

## Migration Plan

- Ship as a client-only UI update; no backend or schema changes.
- Rollback by restoring home app bar actions if needed.

## Open Questions

- None for this change.
