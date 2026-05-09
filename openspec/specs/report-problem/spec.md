## ADDED Requirements

### Requirement: Four-step report flow
The report flow SHALL have exactly four user-visible steps in this order: Details, Location, Review, Success.

#### Scenario: Stepper visibility
- **WHEN** the user is on any step except Success
- **THEN** the `StepperHeader` shows 3 dots with the current step highlighted in `AppColors.reportOrange`

### Requirement: PageView with single controller
The flow SHALL use a single `ReportController` that owns all form state and a `PageController` driving a non-scrollable `PageView`.

#### Scenario: Programmatic advance
- **WHEN** `nextStep()` is called and current-step validation passes
- **THEN** `currentStep` increments and the `PageController` animates to the next page

#### Scenario: Validation blocks advance
- **WHEN** required fields on the current step are empty
- **THEN** `nextStep()` shows a snackbar and the page does not change

### Requirement: Back navigation goes to previous step before exiting
While `currentStep > 0`, system back SHALL move to the previous step; at step 0 it SHALL pop the route.

#### Scenario: Back from step 2
- **WHEN** the user presses system back on step 2
- **THEN** the flow returns to step 1

### Requirement: Required report inputs
The Details step SHALL require: category (`ReportCategory`), title, description. The Location step SHALL require: location text and ward.

#### Scenario: Submit blocked
- **WHEN** any required field is missing
- **THEN** the Submit button on Review remains disabled or shows an error

### Requirement: Submit creates report + media + initial timeline
On submit, the flow SHALL upload selected images to Supabase Storage `media/reports/`, insert a row into `reports`, insert media rows into `report_media`, and insert one `report_timeline` row with status `submitted`.

#### Scenario: Successful submission
- **WHEN** the user taps Submit on the Review step with valid data
- **THEN** all three writes succeed and the flow advances to the Success step

### Requirement: Success step is terminal
The Success step SHALL hide both the app bar and the `StepperHeader`.

#### Scenario: Success layout
- **WHEN** the flow reaches the Success step
- **THEN** the Scaffold's `appBar` and stepper render an empty/zero-height widget
