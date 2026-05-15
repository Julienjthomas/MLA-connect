## Why

The home screen action grid uses a fixed clamp (`200–280px`) for height that doesn't scale correctly across device sizes, causing the MLA Activity section to be pushed off-screen on smaller phones. Citizens need to see MLA Activity without scrolling.

## What Changes

- Replace the fixed-clamp grid height calculation with a fully proportional layout that reserves guaranteed space for the MLA Activity feed below the action grid.
- Action card sizes (height, icon size, font size) scale with available viewport, not fixed pixel values.
- MLA Activity section header is always visible in the initial viewport on all supported device sizes (small ~5", medium ~6", large ~6.7"+).

## Capabilities

### New Capabilities
- `responsive-action-grid`: Proportional action grid sizing that guarantees MLA Activity section visibility in initial viewport across all device sizes.

### Modified Capabilities
<!-- None — existing home layout doesn't have a spec for action grid sizing -->

## Impact

- `lib/features/home/views/home_view.dart` — `_buildActionGrid()` layout calculation
- `lib/core/widgets/action_card.dart` — may need responsive icon/text sizing
- No API changes, no new dependencies
