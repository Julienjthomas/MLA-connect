# compact-home-mla-banner Specification

## Purpose
TBD - created by archiving change compact-mla-hero-banner. Update Purpose after archive.
## Requirements
### Requirement: Compact footprint on home
The home MLA hero banner SHALL occupy at most **88px** of vertical space (including the widget’s own height; horizontal margins excluded). On standard text scale (1.0), the banner SHOULD target **80px** height.

#### Scenario: Banner height on standard phone
- **WHEN** the home screen renders with MLA data loaded at text scale 1.0
- **THEN** the `MlaHeroBanner` bounding height is ≤ 88px

#### Scenario: Banner does not dominate viewport
- **WHEN** the home screen renders on a device with screen height ≥ 640px
- **THEN** the MLA hero uses noticeably less vertical space than the previous ~160px card (roughly half or less)

### Requirement: Horizontal compact layout
The compact banner SHALL use a horizontal layout: circular MLA photo on the left and the MLA full name on the right. The name SHALL be limited to **one line** with ellipsis overflow.

#### Scenario: Photo and name visible
- **WHEN** MLA profile data is available
- **THEN** a circular photo (or placeholder) and the MLA full name are shown in one row

#### Scenario: Long name truncation
- **WHEN** the MLA name exceeds the available width
- **THEN** the name truncates with ellipsis and does not wrap to a second line

### Requirement: No home tagline or heavy decoration
The compact home banner SHALL NOT show the "Your Voice. Our Commitment." tagline, dot-grid decoration, gradient blob, or arc painter behind the photo.

#### Scenario: Minimal chrome
- **WHEN** the compact banner renders
- **THEN** no tagline block and no large decorative background shapes appear

### Requirement: Tap navigates to MLA detail
Tapping the compact banner SHALL navigate to MLA detail, unchanged from current behavior.

#### Scenario: Tap banner
- **WHEN** the user taps the home MLA banner
- **THEN** navigation to MLA detail occurs

### Requirement: Compact loading placeholder
While MLA data is loading, the home hero region SHALL use a placeholder with height matching the compact banner constant (same as loaded banner target, ~80px).

#### Scenario: Loading state
- **WHEN** MLA data is not yet available on home
- **THEN** a loading indicator appears in a box ≤ 88px tall, not ~130px

