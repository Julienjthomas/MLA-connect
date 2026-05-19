## ADDED Requirements

### Requirement: Voice input produces an audio attachment
The voice input widget SHALL emit a completed recording as an audio attachment to the parent flow, not as transcribed text appended to a text field.

#### Scenario: Recording completes
- **WHEN** the user stops a recording
- **THEN** the widget SHALL pass the audio file path to the parent via the `onRecorded` callback for use as an attachment
- **THEN** no text SHALL be injected into any text field by the widget
