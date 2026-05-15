# tab-aware-empty-state Specification

## Purpose
TBD - created by archiving change fix-activity-tabs-content. Update Purpose after archive.
## Requirements
### Requirement: Tab-contextual empty state CTA
The empty state widget for each activity tab SHALL display a primary call-to-action that matches the tab's purpose. The Reports tab SHALL show "Report a Problem", the Ideas tab SHALL show "Share an Idea", the Improvements tab SHALL show "Suggest an Improvement", and the Appreciations tab SHALL show "Appreciate Someone".

#### Scenario: Reports tab empty
- **WHEN** the Reports tab is active and the user has no reports
- **THEN** the empty state shows "Report a Problem" as the primary button and navigates to the report flow on tap

#### Scenario: Ideas tab empty
- **WHEN** the Ideas tab is active and the user has no ideas
- **THEN** the empty state shows "Share an Idea" as the primary button and navigates to the ideas flow on tap

#### Scenario: Improvements tab empty
- **WHEN** the Improvements tab is active and the user has no improvements
- **THEN** the empty state shows "Suggest an Improvement" as the primary button and navigates to the improvements flow on tap

#### Scenario: Appreciations tab empty
- **WHEN** the Appreciations tab is active and the user has no appreciations
- **THEN** the empty state shows "Appreciate Someone" as the primary button and navigates to the appreciation flow on tap

### Requirement: Secondary action cards exclude current tab
The empty state widget SHALL show secondary action cards for the three tabs that are NOT the currently active tab, so the user is not shown a duplicate of the primary CTA.

#### Scenario: Reports tab secondary cards
- **WHEN** the Reports tab is active and empty
- **THEN** the secondary action cards show Share Idea, Suggest Improvement, and Appreciate Someone (no Report a Problem card)

#### Scenario: Ideas tab secondary cards
- **WHEN** the Ideas tab is active and empty
- **THEN** the secondary action cards show Report a Problem, Suggest Improvement, and Appreciate Someone (no Share Idea card)

