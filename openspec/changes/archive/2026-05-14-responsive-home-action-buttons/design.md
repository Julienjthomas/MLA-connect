## Context

Home screen layout (top → bottom): AppBar ~56px, Hero Banner ~130px + 16px gap, Section title ~60px, Action Grid (2×2), Updates header + MLA Activity feed.

Current action grid uses `gridHeight = (screenHeight * 0.30).clamp(200.0, 280.0)`. On a 5" phone (~640px usable height) 30% = 192px → clamped to 200px. Combined with everything above it (~262px) and the section title padding, the MLA Activity section starts near or below the fold. Users must scroll to see it.

No existing spec governs action grid sizing — this is a purely visual layout fix in one widget and one helper widget.

## Goals / Non-Goals

**Goals:**
- MLA Activity section header is always visible without scrolling on all common device sizes (360px–430px wide, 640px–932px tall).
- Action card proportions (icon size, padding, text) scale gracefully so nothing looks cramped on small screens.
- Fix is self-contained — no new dependencies, no API changes.

**Non-Goals:**
- Tablet / landscape layout (out of scope for this change).
- Changing what cards are shown or their order.
- Redesigning the hero banner or other home sections.

## Decisions

### Decision 1: Budget-based height instead of percentage

**Choice:** Calculate available height by subtracting known fixed-height elements from screen height, then cap the action grid to what remains before the fold.

**Rationale:** A percentage (30%) grows too large on tall phones (932px → 280px clamped) and shrinks too small on short phones (640px → 200px, still too big when combined with everything above). A budget approach guarantees the fold constraint.

**Reserved budget (approximate):**
- SafeArea top: 44px
- AppBar: 56px
- Hero banner + gap: 146px
- "What would you like?" header: 52px
- Grid vertical padding: 16px
- MLA Activity header (must be visible): 56px
- Bottom navigation: 60px
- **Total reserved: ~430px**

`maxGridHeight = screenHeight - 430`. Clamp to `[160, 240]` as a safety net for extreme devices.

**Alternative considered:** Keep percentage but lower it to 25% — still doesn't guarantee fold safety across all heights.

### Decision 2: Pass tileSize into ActionCard for responsive internals

**Choice:** Add optional `tileSize` parameter to `ActionCard`. When provided, scale icon container padding and font sizes proportionally.

**Rationale:** A fixed 24px icon + 16px padding inside a tile that is now potentially only 80px tall looks cramped. Scaling icon size to `tileSize * 0.22` (≈18px at 80px tile, ≈24px at 110px tile) keeps visual balance.

**Alternative considered:** Keep ActionCard internals fixed — simpler, but cards look wrong at extreme sizes.

### Decision 3: Keep 2-column fixed grid, no layout mode switching

**Choice:** Always render 2×2 grid, only adjust height.

**Rationale:** 4 actions always fit 2×2; switching to list or horizontal scroll would break the visual language and require more invasive changes. Out of scope.

## Risks / Trade-offs

- `tileSize` calculation assumes hero banner height stays ~130px. If hero content changes size, reserved budget may be off → Mitigate by using slightly conservative budget (add 10px buffer).
- Scaling icon sizes introduces a proportional calculation in `ActionCard` that makes it slightly more complex → Acceptable; complexity is localized.

## Migration Plan

1. Update `_buildActionGrid()` in `home_view.dart` with new height budget formula.
2. Update `ActionCard` to accept optional `tileSize` and scale icon/padding when provided.
3. Verify on small (360×640), medium (390×844), and large (430×932) viewport sizes in simulator.
4. No data migration needed. No feature flag needed. Rollback = revert the two files.

## Open Questions

- Hero banner height is hardcoded as an estimate. Should we read it dynamically? → No, adds complexity. Conservative estimate + clamp handles edge cases.
