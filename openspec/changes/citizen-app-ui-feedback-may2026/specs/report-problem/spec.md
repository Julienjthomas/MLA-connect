## MODIFIED Requirements

### Requirement: Four-step report flow
The report flow SHALL have exactly four user-visible steps in this order: Details, Visibility, Review, Success. Location fields are captured inline on the Details step.

#### Scenario: Stepper visibility
- **WHEN** the user is on any step except Success
- **THEN** the `StepperHeader` shows four steps with the current step highlighted in `AppColors.reportOrange`

### Requirement: Voice input for description
The Details step SHALL include a `VoiceInputWidget` anchored at the bottom-right inside the description field area. The flow SHALL support speech-to-text into the description and SHALL retain a recorded audio attachment for submit when the user records voice.

#### Scenario: Voice control placement
- **WHEN** the Details step renders
- **THEN** the microphone control appears at the bottom-right corner of the description box, not in a separate side column

#### Scenario: Voice transcription
- **WHEN** the user completes speech-to-text for the description
- **THEN** recognized text is appended to the description field

#### Scenario: Voice recording attached on submit
- **WHEN** the user records voice audio and submits a valid report
- **THEN** the audio is uploaded and the submission stores `voice_message_url` (or equivalent) linked to the report

## ADDED Requirements

### Requirement: Report visibility selection
The Visibility step SHALL require the user to choose a `SubmissionVisibility` option before Review. The selected value SHALL be shown on Review and persisted on submit.

#### Scenario: Visibility required
- **WHEN** the user attempts to leave Visibility without a selection
- **THEN** advance is blocked with validation feedback

#### Scenario: Visibility on review
- **WHEN** the user reaches Review
- **THEN** the chosen visibility label is displayed in the summary
