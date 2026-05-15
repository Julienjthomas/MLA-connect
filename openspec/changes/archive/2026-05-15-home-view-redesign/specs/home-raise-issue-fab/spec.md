## ADDED Requirements

### Requirement: Raise New Issue button is persistently visible
The home view SHALL display a full-width "Raise New Issue" button (purple background, white text, + icon prefix) as the last item in the scroll view, with bottom padding to clear the shell navigation bar. Tapping it navigates to the report flow route.

#### Scenario: Button is visible
- **WHEN** the user scrolls to the bottom of the home view
- **THEN** the "Raise New Issue" button is visible

#### Scenario: Button tapped
- **WHEN** user taps "Raise New Issue"
- **THEN** navigation goes to the report issue flow (`Routes.reportFlow`)
