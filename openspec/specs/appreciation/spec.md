## ADDED Requirements

### Requirement: Five-step appreciation flow
The appreciation flow SHALL have exactly five steps: Recipient, Message, Visibility, Review, Success.

#### Scenario: Stepper count
- **WHEN** the user is on any non-Success step
- **THEN** the `StepperHeader` shows 4 dots with `AppColors.appreciateGreen` accent

### Requirement: Recipient inputs
The Recipient step SHALL require: recipient category, staff name (or department), and an optional related-work description.

#### Scenario: Missing recipient
- **WHEN** the user advances without selecting a recipient category
- **THEN** the next step is blocked

### Requirement: Visibility selection
The Visibility step SHALL allow exactly one of: `public`, `mlaOnly`, `anonymous` (`SubmissionVisibility`).

#### Scenario: Anonymous toggle
- **WHEN** the user picks `anonymous`
- **THEN** `anonymous: true` is sent on submit and the user's name is hidden in any public listing

### Requirement: Submit creates appreciation row + media
On submit, the flow SHALL insert into `appreciations` with the chosen visibility and upload any selected images into `media/appreciations/` linked via `appreciation_media`.

#### Scenario: Successful submission
- **WHEN** Submit is tapped on Review with valid data
- **THEN** the appreciation row exists in Supabase and the flow advances to Success
