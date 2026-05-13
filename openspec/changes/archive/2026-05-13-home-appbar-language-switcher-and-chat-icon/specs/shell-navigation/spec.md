## MODIFIED Requirements

### Requirement: Bottom navigation bar tabs
The bottom navigation bar SHALL contain exactly 4 destinations: Home (index 0), My Activity (index 1), Updates (index 2), Profile (index 3). Chat SHALL NOT appear as a bottom navigation destination.

#### Scenario: Bottom nav shows 4 tabs
- **WHEN** user is on any shell screen
- **THEN** bottom navigation bar SHALL display exactly 4 tabs: Home, My Activity, Updates, Profile

#### Scenario: Chat not in bottom nav
- **WHEN** user looks at the bottom navigation bar
- **THEN** no Chat tab SHALL be visible

#### Scenario: Updates tab accessible via View All on home
- **WHEN** user taps "View All" in the MLA Activity section on the home screen
- **THEN** shell SHALL switch to the Updates tab (index 2)

#### Scenario: Activity tab loads data on select
- **WHEN** user taps the My Activity tab (index 1)
- **THEN** `ActivityController.loadActivity()` SHALL be called
