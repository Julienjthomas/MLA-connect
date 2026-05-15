## Context

`ActivityEmptyState` is a single stateless widget used in all four tab bodies (`_ReportsTab`, `_IdeasTab`, `_ImprovementsTab`, `_AppreciationsTab`). It always renders the same UI: a "Report a Problem" primary button plus three secondary action cards. The widget has no knowledge of which tab is active.

## Goals / Non-Goals

**Goals:**
- Each tab's empty state shows a CTA and messaging relevant to that tab
- Minimal change surface — no routing, state, or data layer touched

**Non-Goals:**
- Redesigning the empty state layout or adding animations
- Changing behavior when lists are non-empty

## Decisions

### Add an `ActivityTab` parameter to `ActivityEmptyState`

Accept the current `ActivityTab` enum value as a required constructor parameter. Internally, switch on the tab to vary: title text, subtitle text, primary button label, primary button route, and the accent color/icon. Secondary action cards show the *other three* tabs' CTAs (excluding the current tab's own action to avoid redundancy).

**Alternative considered:** Create four separate empty state widgets (one per tab). Rejected — duplicates layout code with no benefit; a single parameterized widget is simpler.

### Derive CTA config from `ActivityTab` enum extension

Add a helper (extension or static map) on `ActivityTab` that returns the empty state config (label, route, icon, color). Keeps the widget thin and the mapping colocated with the enum.

## Risks / Trade-offs

- [Minor layout shift] Removing the current tab's action card from the secondary row means 3 cards become 2 on some tabs. → Keep 3 cards by showing the remaining three non-current tabs. Since there are always 3 other tabs, this is always balanced.
- [Enum coupling] `ActivityEmptyState` now depends on `ActivityTab`. Acceptable — they are in the same feature domain.

## Migration Plan

1. Update `ActivityEmptyState` to require `ActivityTab tab` parameter.
2. Update each tab widget in `activity_view.dart` to pass its tab value.
3. No data migration, no rollback risk — purely UI.
