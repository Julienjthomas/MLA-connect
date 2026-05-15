# home-quick-actions Specification

## Purpose
TBD - created by archiving change home-quick-actions-cta. Update Purpose after archive.
## Requirements
### Requirement: Quick actions section is a single surfaced card
The home screen SHALL display citizen engagement entry points inside one card titled **Quick actions** (localized), with rounded corners, surface background, and a light border separating it from the page background.

#### Scenario: Citizen views home screen
- **WHEN** an authenticated citizen opens the home screen below the MLA hero banner
- **THEN** a **Quick actions** section SHALL appear as one contiguous card containing the section title and the 2×2 action grid
- **THEN** the previous standalone heading **What would you like to share today?** SHALL NOT be shown

### Requirement: Each quick action tile uses horizontal layout
Each of the four quick action tiles SHALL use a horizontal layout: colored icon chip on the left, primary title and secondary subtitle stacked on the right, on a light gray tile background with rounded corners.

#### Scenario: Tile visual structure
- **WHEN** the quick actions grid renders
- **THEN** each tile SHALL show an icon inside a tinted rounded square using the feature accent color
- **THEN** the title SHALL use primary text color (not accent-colored body text)
- **THEN** the subtitle SHALL use secondary/caption text color

### Requirement: Quick action labels match product copy
The four tiles SHALL use the following English labels (and equivalent Malayalam via l10n):

| Title | Subtitle |
|-------|----------|
| Issue | Report problem |
| Idea | Share thought |
| Suggest | Propose change |
| Appreciate | Recognize work |

#### Scenario: English labels
- **WHEN** the app locale is English
- **THEN** the four tiles SHALL display the title/subtitle pairs listed above

#### Scenario: Malayalam labels
- **WHEN** the app locale is Malayalam
- **THEN** each title and subtitle SHALL display the corresponding Malayalam strings from localization files

### Requirement: Quick actions navigate to existing flows
Tapping a quick action tile SHALL navigate to the same destination as today’s home action grid.

#### Scenario: Issue tile
- **WHEN** the citizen taps **Issue**
- **THEN** the app SHALL navigate to the report-problem flow (`Routes.reportFlow`)

#### Scenario: Idea tile
- **WHEN** the citizen taps **Idea**
- **THEN** the app SHALL navigate to the share-idea flow (`Routes.ideasFlow`)

#### Scenario: Suggest tile
- **WHEN** the citizen taps **Suggest**
- **THEN** the app SHALL navigate to the suggest-improvement flow (`Routes.improvementsFlow`)

#### Scenario: Appreciate tile
- **WHEN** the citizen taps **Appreciate**
- **THEN** the app SHALL navigate to the appreciation flow (`Routes.appreciationFlow`)

### Requirement: Grid order matches design
The 2×2 grid SHALL order tiles as: Issue (top-left), Idea (top-right), Suggest (bottom-left), Appreciate (bottom-right).

#### Scenario: Tile positions
- **WHEN** the quick actions grid renders in LTR layout
- **THEN** Issue SHALL be top-left, Idea top-right, Suggest bottom-left, Appreciate bottom-right

