## MODIFIED Requirements

### Requirement: Required improvement inputs
The Suggestion step SHALL require: suggestion text and department. The Location step SHALL require: location text. The suggestion text control SHALL support long-form entry with at least `minLines: 8` (or a full-screen composer bound to the same controller) and SHALL include `VoiceInputWidget` aligned to the **trailing (right in LTR)** side of that row with automatic speech-to-text merge after recording, matching the report-problem description behavior. No GPS icon SHALL appear in any location field in this flow.

#### Scenario: Missing suggestion text
- **WHEN** suggestion is empty
- **THEN** advance is blocked

#### Scenario: No GPS icon
- **WHEN** any location field renders in the improvement flow
- **THEN** no GPS icon appears as a field prefix or suffix

#### Scenario: Long-form suggestion entry
- **WHEN** the user opens the Suggestion step
- **THEN** the suggestion text area supports detailed multi-line input consistent with the long-form pattern

#### Scenario: Voice transcription for suggestion
- **WHEN** the user completes a voice recording on the suggestion field
- **THEN** the transcript is merged into the suggestion text per the same rules as report descriptions
