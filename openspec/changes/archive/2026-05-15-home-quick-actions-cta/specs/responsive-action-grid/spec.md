## MODIFIED Requirements

### Requirement: Action grid height is viewport-budget-constrained
The quick actions grid inside the home card MAY use content-driven row heights when horizontal tiles are used. If a height budget is applied, it SHALL subtract reserved space for surrounding elements from the screen height so the Updates/MLA Activity section header remains visible without scrolling on the initial viewport for devices with height ≥ 640px.

#### Scenario: Small device (640px height)
- **WHEN** the home screen renders on a device with screen height ≤ 700px
- **THEN** the combined quick actions card height (title + grid) SHALL allow the Updates section header to be visible without scrolling

#### Scenario: Medium device (844px height)
- **WHEN** the home screen renders on a device with screen height between 700px and 900px
- **THEN** the quick actions section SHALL not consume excessive vertical space that pushes the Updates header off the first screenful

#### Scenario: Large device (932px+ height)
- **WHEN** the home screen renders on a device with screen height ≥ 900px
- **THEN** tile row height SHALL NOT grow unbounded; optional max row height MAY cap visual size

#### Scenario: Extreme small screen safety
- **WHEN** calculated or intrinsic grid height would compress tiles below readable minimum
- **THEN** the system SHALL enforce a minimum tile height so titles remain legible (ellipsis allowed)

### Requirement: Action card internals scale with tile size
When an optional tile size hint is provided to `ActionCard`, the widget SHALL scale icon and padding as today. **Quick action horizontal tiles** SHALL NOT require `tileSize`; they SHALL use fixed compact dimensions (icon ~20–22px, chip padding ~8–10px) suitable for ~72–88px row height.

#### Scenario: Quick action tile on home
- **WHEN** `QuickActionTile` (or horizontal layout) renders on the home screen
- **THEN** icon and padding SHALL use compact fixed sizes without passing `tileSize`

#### Scenario: Legacy ActionCard with tileSize
- **WHEN** `tileSize` is passed to vertical `ActionCard` elsewhere
- **THEN** existing scaling behavior SHALL be preserved

#### Scenario: No tile size provided
- **WHEN** `tileSize` is not passed to vertical `ActionCard`
- **THEN** ActionCard SHALL use its default fixed sizes (existing behavior preserved)

### Requirement: MLA Activity section always in initial viewport
The Updates section header (labeled per current product copy, e.g. **Updates**) SHALL be visible without scrolling on first render on all device sizes with screen height ≥ 640px.

#### Scenario: Citizen opens home screen
- **WHEN** an authenticated citizen opens the home screen
- **THEN** the Updates section header SHALL be visible in the initial viewport without any scroll gesture on any phone with height ≥ 640px
