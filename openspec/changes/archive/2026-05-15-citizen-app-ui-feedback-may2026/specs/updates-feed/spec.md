## MODIFIED Requirements

### Requirement: Like action on updates
Each update card and the update detail view SHALL show a like button. Tapping it SHALL toggle a like for the current user and SHALL persist the like through the engagement service for authenticated users. The UI SHALL reflect server-backed liked state after feed load.

#### Scenario: Like an update
- **WHEN** the user taps the like button on an update
- **THEN** the like count increments by 1, the icon changes to filled state, and a like row is written for the current user

#### Scenario: Unlike an update
- **WHEN** the user taps the like button on an already-liked update
- **THEN** the like count decrements by 1, the icon reverts to outline state, and the user's like row is removed

#### Scenario: Hydrate liked state on load
- **WHEN** updates are loaded for a signed-in user
- **THEN** tiles and detail views mark posts the user already liked with filled like icons

### Requirement: View All navigates to Updates Listing
The "View All" control in the Updates section on the Home page SHALL navigate to the full Updates tab or a dedicated updates listing page. The home section header SHALL use the localized Updates label, not "MLA Activity".

#### Scenario: Tap View All
- **WHEN** the user taps "View All" in the Home page Updates section
- **THEN** the Updates tab is activated or `Routes.updatesList` is pushed

#### Scenario: Home section title
- **WHEN** the home Updates section header renders
- **THEN** the title text is the localized Updates string

## ADDED Requirements

### Requirement: Home update carousel tile width
The home Updates horizontal carousel SHALL size each tile so approximately 2.5 tiles are visible on a typical phone width at once, with horizontal scrolling for additional items.

#### Scenario: Peek third tile
- **WHEN** the home screen renders on a standard phone width with at least three updates
- **THEN** roughly two full tiles and a partial third tile are visible without scrolling

#### Scenario: Horizontal scroll
- **WHEN** the user swipes horizontally on the home Updates carousel
- **THEN** additional update tiles scroll into view
