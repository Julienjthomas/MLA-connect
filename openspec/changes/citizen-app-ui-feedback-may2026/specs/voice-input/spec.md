## ADDED Requirements

### Requirement: Overlay placement mode for long-form fields
`VoiceInputWidget` SHALL support an overlay placement mode for multiline text fields where the primary microphone control is positioned at the bottom-right inside the field bounds without reducing the text field's usable width.

#### Scenario: Overlay mode on report description
- **WHEN** the widget is used with overlay placement on a multiline description field
- **THEN** the mic control renders inside the field's bottom-right padding and the text field remains full width

#### Scenario: Dictation in overlay mode
- **WHEN** the user taps the overlay mic and completes dictation
- **THEN** the parent `onTranscript` callback receives the recognized text

### Requirement: Parent receives recorded file path
When recording mode is used, stopping a recording SHALL invoke `onRecorded` with the local file path so the parent flow can upload and attach the audio on submit.

#### Scenario: Stop recording invokes callback
- **WHEN** the user stops a voice recording in recording mode
- **THEN** `onRecorded` is called with a non-empty local file path
