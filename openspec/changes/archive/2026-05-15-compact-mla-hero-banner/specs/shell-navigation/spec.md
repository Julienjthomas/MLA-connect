## MODIFIED Requirements

### Requirement: Home banner — clean minimal style
The MLA hero banner on the Home tab SHALL display only the MLA’s **photo** and **full name** in a **compact horizontal strip** with maximum height **88px** (target **80px** at default text scale). It SHALL NOT display constituency labels, the literal “MLA” role label, stat counts, location symbols, verified ticks, taglines, or background chrome that competes with the photo beyond a simple light backdrop.

#### Scenario: Name and photo only
- **WHEN** the home screen renders
- **THEN** the hero shows the MLA portrait and the MLA full name as the primary text in a single compact row

#### Scenario: Compact height
- **WHEN** the banner renders at default text scale
- **THEN** the banner height is ≤ 88px

#### Scenario: No constituency label on hero
- **WHEN** the banner renders
- **THEN** no assembly constituency or panchayath string appears on the hero

#### Scenario: No stat counts
- **WHEN** the banner renders
- **THEN** no numeric stat counters (reports, ideas, etc.) are shown on the banner

#### Scenario: No tagline on hero
- **WHEN** the banner renders
- **THEN** no marketing tagline or multi-line subtitle appears below the name
