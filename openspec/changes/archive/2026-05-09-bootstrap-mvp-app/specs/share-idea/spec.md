## ADDED Requirements

### Requirement: Five-step idea flow
The share-idea flow SHALL have exactly five steps: Details, Impact, Visibility, Review, Success.

#### Scenario: Stepper accent color
- **WHEN** the user is on any non-Success step
- **THEN** the `StepperHeader` accent is `AppColors.ideaPurple`

### Requirement: Required idea inputs
The Details step SHALL require: topic, title, description. The Impact step SHALL require: benefits and at least one beneficiary group.

#### Scenario: Missing benefits
- **WHEN** the user leaves Benefits blank on the Impact step
- **THEN** advance is blocked

### Requirement: Discussion and contact toggles
The flow SHALL capture `allow_discussion` and `allow_contact` boolean preferences (default true).

#### Scenario: Defaults at submit
- **WHEN** the user does not change either toggle
- **THEN** both are submitted as `true`

### Requirement: Submit creates ideas row
On submit, the flow SHALL insert into the `ideas` table with all collected fields and advance to Success.

#### Scenario: Successful submission
- **WHEN** Submit is tapped with valid data
- **THEN** the row exists with `status = 'submitted'`
