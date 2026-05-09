## ADDED Requirements

### Requirement: Four-tab bottom navigation shell
The home shell SHALL present exactly four tabs in this order: Home, My Activity, Updates, Profile.

#### Scenario: Tab labels and order
- **WHEN** the home shell renders
- **THEN** the bottom navigation shows Home, My Activity, Updates, Profile from left to right

### Requirement: Tabs preserve state via IndexedStack
Tab content SHALL be wrapped in an `IndexedStack` so scroll position and controller state persist when switching tabs.

#### Scenario: Scroll persists
- **WHEN** the user scrolls in the Home tab, switches to Updates, and returns to Home
- **THEN** the Home tab's scroll offset is unchanged

### Requirement: Tab switch does not push a route
Switching tabs SHALL update `ShellController.currentIndex` without invoking `Get.toNamed` or pushing routes.

#### Scenario: Back button after tab switch
- **WHEN** the user is on the home route, switches tabs, then presses system back
- **THEN** the app exits (or shows confirm) instead of switching tabs

### Requirement: Sub-screens push as named routes
Detail screens (e.g., MLA detail, update detail, report detail) SHALL be navigated via `Get.toNamed` and appear above the shell.

#### Scenario: Open update detail
- **WHEN** the user taps an update card
- **THEN** `Routes.updateDetail` is pushed with the update id as `arguments`
