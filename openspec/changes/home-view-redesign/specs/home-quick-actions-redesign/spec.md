## ADDED Requirements

### Requirement: Quick actions section has updated header
The quick actions section SHALL display the header text "What would you like to do?" instead of "Quick Actions".

#### Scenario: Section header text
- **WHEN** the home view renders the quick actions section
- **THEN** the header reads "What would you like to do?"

### Requirement: Quick action tiles use vertical card layout
Each quick action tile SHALL use a vertical card layout: icon centered at top within a colored circle badge, bold title below, subtitle/description text below title, small arrow indicator at bottom. The four actions are: Report Issue (orange, "Roads, water, safety & more"), Share Idea (purple, "Suggest ideas for a better future"), Request Help (blue, "Seek help or report a problem"), Appreciate Work (green, "Thank people or projects").

#### Scenario: Tile renders vertical layout
- **WHEN** a quick action tile is displayed
- **THEN** icon appears centered at top, title below, subtitle below title, arrow at bottom

#### Scenario: All four tiles present
- **WHEN** the quick actions section renders
- **THEN** Report Issue, Share Idea, Request Help, and Appreciate Work tiles are all visible
