## Purpose

Define the citizen report-problem submission flow and validation rules.

## Requirements

### Requirement: Four-step report flow
The report flow SHALL have exactly three user-visible steps in this order: Details, Review, Success. The separate Location step is removed; location fields are captured inline on the Details step.

#### Scenario: Stepper visibility
- **WHEN** the user is on any step except Success
- **THEN** the `StepperHeader` shows 2 dots with the current step highlighted in `AppColors.reportOrange`

### Requirement: Required report inputs
The Details step SHALL require: category (chip selection), title, description, panchayath (dropdown), ward (dropdown), and location text. No separate Location step exists.

#### Scenario: Submit blocked
- **WHEN** any required field is missing
- **THEN** the Submit button on Review remains disabled or shows an error

### Requirement: Category selection via chips
Category SHALL be selected using a wrap of `FilterChip` widgets, not a dropdown. All `ReportCategory` values are shown.

#### Scenario: Category chip selection
- **WHEN** the user taps a chip
- **THEN** that chip becomes selected and all others deselect

### Requirement: Description character limit
The description field SHALL allow up to 1500 characters (not 500). The field SHALL show remaining character count.

#### Scenario: Long description
- **WHEN** the user types 501 characters
- **THEN** input is not blocked and the character counter reflects the remaining count

### Requirement: Expanded description field
The description `TextField` SHALL have `minLines: 5` and `maxLines: 10` to occupy more vertical space.

#### Scenario: Description box size
- **WHEN** the Details step renders
- **THEN** the description box is taller than any single-line field on the same step

### Requirement: Geo dropdowns for Panchayath and Ward
Panchayath and Ward SHALL each be a `DropdownButtonFormField` populated from static constant lists. Selecting a panchayath SHALL reset the ward selection.

#### Scenario: Panchayath selected
- **WHEN** the user selects a panchayath
- **THEN** the ward dropdown is reset and shows only wards for that panchayath (or all wards if not filtered)

#### Scenario: Ward required
- **WHEN** ward is not selected
- **THEN** advance is blocked

### Requirement: No GPS icon or hint in location description
The location text field SHALL NOT show a GPS/location icon or any hint text referencing GPS commands.

#### Scenario: Location field renders
- **WHEN** the Details step renders
- **THEN** no GPS icon appears in the location description field prefix or suffix

### Requirement: No Pin on Map option
The report flow SHALL NOT include any "Pin on Map" or map-picker option.

#### Scenario: No map picker
- **WHEN** the Details step renders
- **THEN** no map button or map picker widget is present

### Requirement: Voice input for description
The Details step SHALL include a `VoiceInputWidget` beside the description field, allowing voice recording that populates the description.

#### Scenario: Voice transcription
- **WHEN** the user records voice and stops
- **THEN** the recorded file path is stored and the description field is optionally pre-filled or the recording is attached

### Requirement: Media upload cap
The media picker SHALL allow a maximum of 10 files (images/video combined).

#### Scenario: Attempt to add 11th file
- **WHEN** the user tries to add more than 10 media files
- **THEN** a snackbar shows "Maximum 10 files allowed" and the new file is not added

### Requirement: No location option in Gradual Update tab
If a Gradual Update tab/option exists in the report flow, it SHALL NOT include a location field.

#### Scenario: Gradual Update tab
- **WHEN** the Gradual Update option is active
- **THEN** no location input is rendered in that context

### Requirement: Submit creates report + media + initial timeline
On submit, the flow SHALL upload selected images to Supabase Storage bucket `submission-objects` under `problems/{auth_user_id}/…`, insert a row into `submissions` with `kind='report'`, insert media rows into `media_attachments` linked to that submission, and insert one `submission_status_history` row with status `submitted`. Submit SHALL succeed when all required fields are filled and Storage authorization succeeds.

#### Scenario: Successful submission
- **WHEN** the user taps Submit on the Review step with valid data and attachments
- **THEN** Storage uploads complete without RLS errors
- **THEN** database writes succeed, the flow advances to Success, and no error is shown

#### Scenario: Submit failure shows error
- **WHEN** the Supabase insert or Storage upload fails
- **THEN** an error snackbar is shown and the user remains on the Review step
