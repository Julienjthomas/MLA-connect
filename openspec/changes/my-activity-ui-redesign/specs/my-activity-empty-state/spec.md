## ADDED Requirements

### Requirement: Activity empty state layout
When any activity tab (Reports, Ideas, Improvements, Appreciations) has no submissions, the screen SHALL display an `ActivityEmptyState` widget with: an illustration at the top, a headline, a full-width primary "Report a Problem" button, and a 3-column secondary action row containing Share Idea, Suggest Improvement, and Appreciate tiles.

#### Scenario: Empty Reports tab
- **WHEN** the user has no reports and is on the Reports tab
- **THEN** the empty state shows illustration, headline, "Report a Problem" primary button, and three secondary action cards

#### Scenario: Empty Ideas tab
- **WHEN** the user has no ideas and is on the Ideas tab
- **THEN** the same empty state layout appears with the same four actions

#### Scenario: Empty Improvements tab
- **WHEN** the user has no improvements and is on the Improvements tab
- **THEN** the same empty state layout appears

#### Scenario: Empty Appreciations tab
- **WHEN** the user has no appreciations and is on the Appreciations tab
- **THEN** the same empty state layout appears

### Requirement: Empty state primary action
The primary button SHALL navigate to the report problem flow (`Routes.reportFlow`) when tapped.

#### Scenario: Primary button tap
- **WHEN** user taps "Report a Problem" in the empty state
- **THEN** the app navigates to the report problem flow

### Requirement: Empty state secondary actions
The 3-column action row SHALL contain exactly three tiles: Share Idea (→ `Routes.ideasFlow`), Suggest Improvement (→ `Routes.improvementsFlow`), Appreciate (→ `Routes.appreciationFlow`). No "Chat with MLA Office" tile SHALL appear.

#### Scenario: Share Idea tile tap
- **WHEN** user taps the Share Idea tile in the empty state
- **THEN** the app navigates to the ideas flow

#### Scenario: Suggest Improvement tile tap
- **WHEN** user taps the Suggest Improvement tile in the empty state
- **THEN** the app navigates to the improvements flow

#### Scenario: Appreciate tile tap
- **WHEN** user taps the Appreciate tile in the empty state
- **THEN** the app navigates to the appreciation flow

#### Scenario: No chat action
- **WHEN** the empty state renders
- **THEN** no "Chat with MLA Office" or similar chat action is visible
