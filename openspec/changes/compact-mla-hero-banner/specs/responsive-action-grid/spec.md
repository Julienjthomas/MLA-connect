## MODIFIED Requirements

### Requirement: Action grid height is viewport-budget-constrained
When viewport-budget logic is used on the home screen, the reserved vertical budget for non-grid content SHALL assume a **compact MLA hero of ~80px** (plus standard section gaps), not the legacy ~130–160px hero card. Quick actions MAY use intrinsic/content-driven heights; the smaller hero SHALL increase likelihood that the Updates section header is visible without scrolling on devices with height ≥ 640px.

#### Scenario: Small device (640px height)
- **WHEN** the home screen renders on a device with screen height ≤ 700px
- **THEN** surrounding chrome including the compact MLA hero SHALL leave sufficient viewport for the Updates section header to be reachable with minimal or no scroll

#### Scenario: Medium device (844px height)
- **WHEN** the home screen renders on a device with screen height between 700px and 900px
- **THEN** the home layout SHALL benefit from the reduced hero footprint compared to the prior large banner

#### Scenario: Large device (932px+ height)
- **WHEN** the home screen renders on a device with screen height ≥ 900px
- **THEN** the compact hero SHALL NOT expand back to a large card solely on large screens

#### Scenario: Extreme small screen safety
- **WHEN** calculated grid height would compress tiles below readable minimum
- **THEN** the system SHALL enforce a minimum tile height so titles remain legible (ellipsis allowed)
