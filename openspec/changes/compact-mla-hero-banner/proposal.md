## Why

The home-screen MLA hero banner (`MlaHeroBanner`) currently uses a fixed 160px height, a 110×128px photo stack, large typography, and decorative chrome (dot grid, gradient blob, tagline). On typical phones this consumes roughly one-third of the viewport above the fold, pushing Quick actions and Updates down and making the home screen feel MLA-heavy rather than action-oriented.

## What Changes

- Shrink the MLA hero to a **compact horizontal strip** (target ~72–88px total height) that still shows photo + name and remains tappable to MLA detail.
- Scale down photo, typography, padding, corner radius, and decorative elements proportionally—or remove nonessential decoration if it no longer fits at small size.
- Replace the tagline ("Your Voice. Our Commitment.") on the home hero with nothing or a single-line constituency hint only if it fits without increasing height.
- Align the loading placeholder in `home_view.dart` with the new compact height (today ~130px).
- Revisit any viewport-budget constants that assume a ~130–160px hero when sizing the action grid.

## Capabilities

### New Capabilities

- `compact-home-mla-banner`: Compact home MLA hero dimensions, content hierarchy, visual treatment, tap behavior, and loading state.

### Modified Capabilities

- `shell-navigation`: Home banner requirement gains an explicit maximum footprint so the hero stays a small strip, not a large card.
- `responsive-action-grid`: Reserved hero budget in home layout math updated to match the compact banner height.

## Impact

- `lib/features/home/widgets/mla_hero_banner.dart` — layout, sizing, optional decoration trim
- `lib/features/home/views/home_view.dart` — hero loading placeholder height; possible grid budget tweak
- `openspec/specs/shell-navigation/spec.md` — delta for compact banner footprint (via change spec)
- `openspec/specs/responsive-action-grid/spec.md` — delta for hero reserved height (via change spec)
- No API, routing, or backend changes
