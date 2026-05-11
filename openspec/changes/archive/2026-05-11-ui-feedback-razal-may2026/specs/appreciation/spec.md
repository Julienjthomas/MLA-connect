## MODIFIED Requirements

### Requirement: Visibility selection
The Visibility step SHALL allow exactly one of: `public`, `mlaOnly`, `anonymous` (`SubmissionVisibility`). The UI SHALL present exactly three distinct options — no duplicate or redundant anonymous entries.

#### Scenario: Anonymous toggle
- **WHEN** the user picks `anonymous`
- **THEN** `anonymous: true` is sent on submit and the user's name is hidden in any public listing

#### Scenario: No duplicate options
- **WHEN** the Visibility step renders
- **THEN** exactly three options appear and `anonymous` appears only once

## ADDED Requirements

### Requirement: Keyboard dismissal on tap outside
Any text field in the appreciation flow SHALL dismiss the keyboard when the user taps anywhere outside the keyboard or text field area.

#### Scenario: Tap outside keyboard
- **WHEN** a text field is focused and keyboard is visible
- **THEN** tapping outside the field dismisses the keyboard without submitting the form
