## ADDED Requirements

### Requirement: Voice control trailing alignment
For LTR layouts, the recording control SHALL be placed on the **right** side of the associated text field row unless an explicit parent layout parameter overrides placement; RTL layouts SHALL mirror horizontally.

#### Scenario: LTR mic on right
- **WHEN** `VoiceInputWidget` renders beside a multiline field in an LTR locale
- **THEN** the mic/stop control is closer to the right screen edge than the text field’s leading edge

### Requirement: Automatic transcription after recording
After a successful stop of recording, the widget stack SHALL invoke on-device speech-to-text (or configured STT provider) to produce a transcript string and notify the parent via a dedicated callback (e.g. `onTranscript`) in addition to any existing `onRecorded` audio path.

#### Scenario: Transcript callback
- **WHEN** transcription succeeds
- **THEN** the parent receives a non-empty transcript string suitable to merge into bound form text

#### Scenario: Transcription error
- **WHEN** transcription fails
- **THEN** the parent receives an error signal or empty transcript with error metadata and the UI does not crash
