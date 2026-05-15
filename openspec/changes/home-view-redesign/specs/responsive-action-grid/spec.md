## MODIFIED Requirements

### Requirement: Quick action tile layout
Each quick action tile SHALL use a vertical card layout with icon at top (centered, inside a rounded color badge), bold title text, subtitle/description text, and a small arrow chevron. Tile minimum height SHALL be 130dp to accommodate vertical stacking. Background is white/surface with subtle border.

#### Scenario: Tile renders all elements
- **WHEN** a QuickActionTile is displayed in vertical mode
- **THEN** icon, title, subtitle, and arrow chevron are all visible in vertical order

#### Scenario: Tile responds to tap
- **WHEN** user taps the tile
- **THEN** the onTap callback fires
