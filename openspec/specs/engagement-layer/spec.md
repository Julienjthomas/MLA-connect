## ADDED Requirements

### Requirement: Events section is tappable
The bottom Events section on the home screen SHALL be a tappable surface that navigates the user to an events list or detail screen.

#### Scenario: User taps events section
- **WHEN** the user taps anywhere inside the Events section card on home
- **THEN** the app SHALL navigate to the events route

### Requirement: Home includes an additional content section
The home screen SHALL include one additional scrollable content section below existing sections to enrich the feed (e.g. "Community Impact" summary of constituency-level submissions this month).

#### Scenario: Scrolling home screen
- **WHEN** the user scrolls past the existing home sections
- **THEN** an additional section SHALL appear with summary content sourced from existing submission data
