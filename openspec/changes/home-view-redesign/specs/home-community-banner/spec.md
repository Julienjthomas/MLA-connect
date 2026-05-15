## ADDED Requirements

### Requirement: Community hero banner renders
The home view SHALL display a full-width community hero banner with a purple gradient background, a bold headline ("Let's build a better tomorrow, together."), a subtext line ("Share issues, ideas and appreciate good work."), and an illustration image on the right side.

#### Scenario: Banner renders
- **WHEN** the home view is displayed
- **THEN** the purple gradient banner with headline and subtext is visible

### Requirement: Community banner shows issue stats row
The banner SHALL display a dark semi-transparent stats row at the bottom with three counters: Active Issues, In Progress, Resolved. Values are sourced from MlaStats (activeProjects proxy for Active Issues, issuesResolved for Resolved).

#### Scenario: Stats row shows values
- **WHEN** MLA data is loaded
- **THEN** the stats row displays numeric counts for Active Issues, In Progress, and Resolved

#### Scenario: Stats row shows zero state
- **WHEN** MLA data has zero values
- **THEN** stats row shows "0" for each counter
