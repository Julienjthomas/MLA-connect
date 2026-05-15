## ADDED Requirements

### Requirement: Voice input on idea description
The Share Idea Details step SHALL include voice input on the idea description field using the same overlay placement and dictation or recording behavior as the report problem description step.

#### Scenario: Voice control on idea details
- **WHEN** the Idea Details step renders
- **THEN** a `VoiceInputWidget` is available on the description field at the bottom-right inside the field area

#### Scenario: Dictation fills description
- **WHEN** the user completes speech-to-text on the idea description
- **THEN** recognized text is appended to the idea description field
