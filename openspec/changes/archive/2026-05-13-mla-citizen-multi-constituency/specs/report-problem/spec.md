## MODIFIED Requirements

### Requirement: Expanded description field
The description `TextField` SHALL use at least `minLines: 8` and at least `maxLines: 16` on the Details step, and SHALL offer an affordance (e.g. expand icon) that opens a full-screen composer editing the same description text.

#### Scenario: Tall field
- **WHEN** the Details step renders
- **THEN** the description box occupies substantially more vertical space than single-line inputs

#### Scenario: Full-screen composer
- **WHEN** the user opens the full-screen composer from the affordance
- **THEN** a dedicated screen allows long-form editing of the same description value and returns to Details on dismiss

### Requirement: Voice input for description
The Details step SHALL include `VoiceInputWidget` aligned to the **trailing (right in LTR)** edge of the description row. When recording completes, the app SHALL run automatic speech-to-text and merge the resulting transcript into the description field (append with a leading newline if the field is non-empty; replace if empty).

#### Scenario: Mic on the right
- **WHEN** the Details step renders in an LTR locale
- **THEN** the voice control appears to the right of the description field within the same row or trailing-aligned column

#### Scenario: Transcription merges into description
- **WHEN** the user finishes a successful recording and transcription returns text
- **THEN** the description field contains that text merged per the merge rules above

#### Scenario: Transcription failure
- **WHEN** transcription fails or is unavailable
- **THEN** the app shows a non-blocking error and leaves any typed description intact
