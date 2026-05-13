## MODIFIED Requirements

### Requirement: Four-tab bottom navigation shell
The home shell SHALL present exactly four tabs in this order: Home, My Activity, Updates, Profile.

#### Scenario: Tab labels and order
- **WHEN** the home shell renders
- **THEN** the bottom navigation shows Home, My Activity, Updates, Profile from left to right

## ADDED Requirements

### Requirement: Home banner — clean minimal style
The MLA hero banner SHALL show the MLA name and constituency label. The MLA label ("MLA") and the MLA name SHALL have visually distinct styles and font sizes. No tick/verified mark, no location symbol, and no stat counts SHALL appear on the banner. Banner color intensity SHALL be reduced (lower opacity or lighter palette).

#### Scenario: No tick or location symbol
- **WHEN** the home screen renders
- **THEN** no verified checkmark and no location pin icon appear in the banner

#### Scenario: No stat counts
- **WHEN** the banner renders
- **THEN** no numeric stat counters (reports, ideas, etc.) are shown on the banner

#### Scenario: Distinct MLA label style
- **WHEN** the banner renders
- **THEN** the "MLA" label has a smaller or lighter style than the MLA name

### Requirement: Home page font sizes
General text on the home page SHALL be slightly larger than the current defaults to improve readability.

#### Scenario: Legibility check
- **WHEN** the home page renders
- **THEN** body text uses at least 14sp and section headers use at least 16sp

### Requirement: Language switch sync
The language toggle in the app bar SHALL read and reflect the current active locale. Switching language SHALL immediately update all UI strings.

#### Scenario: Language already set
- **WHEN** the home page opens and the app locale is Malayalam
- **THEN** the language toggle shows Malayalam as selected

#### Scenario: Alignment on toggle
- **WHEN** the language selection button renders
- **THEN** its label and icon are horizontally and vertically aligned with no overflow

### Requirement: Main option tiles fit without scroll
The four main option tiles on the home page SHALL be sized so all four are visible on screen without vertical scrolling. Appreciate SHALL be in the 4th position (last).

#### Scenario: Tile order
- **WHEN** the home page renders
- **THEN** tiles appear: Report Problem, Share Idea, Suggest Improvement, Appreciate

#### Scenario: No scroll needed
- **WHEN** the home page renders on a standard phone screen
- **THEN** all four tiles are visible without scrolling

### Requirement: Suggest Improvement icon distinct from app logo
The Suggest Improvement tile SHALL use an icon that differs visually from the main app logo.

#### Scenario: Icons differ
- **WHEN** the home page renders
- **THEN** the Suggest Improvement tile icon is not identical to the app launcher icon

### Requirement: Updates section on home renamed and wired
The section previously labelled "MLA Activity" SHALL be labelled "Updates". The "View All" button SHALL navigate to the Updates tab or listing page.

#### Scenario: Label renamed
- **WHEN** the home page renders
- **THEN** the section heading reads "Updates" not "MLA Activity"

#### Scenario: View All tap
- **WHEN** the user taps "View All" in the Updates section
- **THEN** the Updates tab becomes active or the updates listing page opens

### Requirement: Hall of Excellence banner is tappable
The Hall of Excellence banner on the home page SHALL be wrapped in a tap gesture that navigates to the Achievements Listing page.

#### Scenario: Tap banner
- **WHEN** the user taps the Hall of Excellence banner
- **THEN** `Routes.achievementsListing` is pushed

### Requirement: Achievement input provision
The app SHALL provide a route and basic screen stub at `Routes.achievementsListing` that lists achievements and includes a floating action button for adding a new achievement.

#### Scenario: Listing screen opens
- **WHEN** `Routes.achievementsListing` is pushed
- **THEN** a screen renders showing existing achievements (or empty state) and an Add FAB

### Requirement: Home header shows selected constituency name
The home shell header/MLA banner SHALL display the user's selected constituency name (from their profile) dynamically, not as a hardcoded string.

#### Scenario: Constituency name rendered from profile
- **WHEN** the home shell renders for a logged-in user
- **THEN** the MLA banner or home header subtitle shows the user's constituency name from their profile

#### Scenario: Fallback when constituency name unavailable
- **WHEN** the user's profile has no constituency name resolvable
- **THEN** the header subtitle is omitted or shows an empty state gracefully (no crash, no "Balussery")
