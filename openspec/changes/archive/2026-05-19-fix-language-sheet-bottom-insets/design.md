## Context

`ProfileController.pickLanguage` renders a `showModalBottomSheet` with a hardcoded bottom padding of `32px`. On Android devices using gesture navigation, the system nav bar overlaps the bottom of the sheet. The fix is a one-line change: wrap the `Padding` widget in a `SafeArea(top: false)` and reduce the static bottom padding from `32` to `8` so `SafeArea` handles the inset dynamically.

## Goals / Non-Goals

**Goals:**
- Sheet content clears system navigation bar on all Android nav modes (gesture, 3-button)
- Sheet content clears iPhone home indicator
- No visual regression on devices without bottom insets

**Non-Goals:**
- Refactoring the sheet into a standalone widget
- Changing sheet height or `isScrollControlled` behavior
- Fixing other bottom sheets in the app

## Decisions

**Use `SafeArea(top: false)` wrapping the `Padding`**
- Alternative: `MediaQuery.of(ctx).padding.bottom` manual offset — more verbose, same result
- `SafeArea` is idiomatic Flutter and handles all inset sources (notch, nav bar, home indicator) automatically. Chosen for simplicity.

**Keep static `bottom: 8` inside the Padding**
- Provides visual breathing room above the safe area boundary
- `0` feels too tight; `32` was the original (now redundant) value

## Risks / Trade-offs

- [Minimal] `SafeArea` adds a small extra padding on devices that report no bottom inset → visually identical, net positive
- No rollback needed; change is purely cosmetic/layout
