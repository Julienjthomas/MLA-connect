## ADDED Requirements

### Requirement: Update cards show status badge
Each recent update card in the horizontal feed SHALL display a colored status badge chip overlaid on the top-left of the thumbnail image. Badge colors: "In Progress" = orange, "Resolved" = green, "New" = blue. If status is unknown or null, default to "New" badge.

#### Scenario: Card with known status
- **WHEN** an update item has a status of "In Progress", "Resolved", or "New"
- **THEN** the corresponding colored badge is overlaid on the card thumbnail

#### Scenario: Card with null status
- **WHEN** an update item has no status value
- **THEN** a "New" blue badge is shown
