## ADDED Requirements

### Requirement: Action grid height is viewport-budget-constrained
The action grid height SHALL be calculated by subtracting a reserved budget for surrounding elements from the total screen height, ensuring the MLA Activity section header is always visible without scrolling on the initial viewport.

#### Scenario: Small device (640px height)
- **WHEN** the home screen renders on a device with screen height ≤ 700px
- **THEN** the action grid height SHALL be ≤ 220px so that the MLA Activity section header is visible without scrolling

#### Scenario: Medium device (844px height)
- **WHEN** the home screen renders on a device with screen height between 700px and 900px
- **THEN** the action grid height SHALL scale proportionally between 220px and 240px

#### Scenario: Large device (932px+ height)
- **WHEN** the home screen renders on a device with screen height ≥ 900px
- **THEN** the action grid height SHALL not exceed 240px (upper clamp)

#### Scenario: Extreme small screen safety
- **WHEN** calculated grid height falls below 160px
- **THEN** the system SHALL clamp to a minimum of 160px to prevent unreadable cards

### Requirement: Action card internals scale with tile size
When an optional tile size hint is provided, the ActionCard widget SHALL scale its icon container size and internal padding proportionally so cards remain visually balanced at any grid height.

#### Scenario: Small tile (≤ 90px)
- **WHEN** tileSize ≤ 90px is passed to ActionCard
- **THEN** icon size SHALL be ≤ 20px and internal padding SHALL be ≤ 8px

#### Scenario: Standard tile (> 90px)
- **WHEN** tileSize > 90px is passed to ActionCard
- **THEN** icon size SHALL be 24px and internal padding SHALL be the default 16px

#### Scenario: No tile size provided
- **WHEN** tileSize is not passed to ActionCard
- **THEN** ActionCard SHALL use its default fixed sizes (existing behavior preserved)

### Requirement: MLA Activity section always in initial viewport
The MLA Activity section header SHALL be visible without scrolling on first render on all device sizes with screen height ≥ 640px.

#### Scenario: Citizen opens home screen
- **WHEN** an authenticated citizen opens the home screen
- **THEN** the "MLA Activity" section header SHALL be visible in the initial viewport without any scroll gesture on any phone with height ≥ 640px
