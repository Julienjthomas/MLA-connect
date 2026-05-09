## ADDED Requirements

### Requirement: Four-step improvement flow
The suggest-improvement flow SHALL have exactly four steps: Suggestion, Location, Review, Success.

#### Scenario: Stepper accent color
- **WHEN** the user is on any non-Success step
- **THEN** the `StepperHeader` accent is `AppColors.improveBlue`

### Requirement: Required improvement inputs
The Suggestion step SHALL require: suggestion text and department. The Location step SHALL require: location text.

#### Scenario: Missing suggestion text
- **WHEN** suggestion is empty
- **THEN** advance is blocked

### Requirement: Submit creates improvements row
On submit, the flow SHALL insert into `improvements` with `status = 'submitted'` and advance to Success.

#### Scenario: Successful submission
- **WHEN** Submit is tapped with valid data
- **THEN** the row exists in Supabase
