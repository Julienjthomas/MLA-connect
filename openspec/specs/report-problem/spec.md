## ADDED Requirements

### Requirement: Report reference ID is a random UUID
On report submission the system SHALL generate a random UUID (v4) as the report reference ID. The ID SHALL be globally unique and persisted with the report.

#### Scenario: New report submission
- **WHEN** the user completes a report submission
- **THEN** the system generates a UUID v4, persists it as the report's reference ID, and shows it on the success step

#### Scenario: Reference ID uniqueness
- **WHEN** two reports are submitted in succession
- **THEN** their reference IDs SHALL differ

### Requirement: Voice input as separate attachment
The report details step SHALL expose an "Insert Voice Message" attachment option, parallel to image upload, that produces an audio attachment on the report. Voice capture SHALL NOT inject transcribed text into the description field.

#### Scenario: User adds voice message
- **WHEN** the user taps "Insert Voice Message" and completes a recording
- **THEN** the recording SHALL appear as a voice attachment alongside any image attachments
- **THEN** the description text field SHALL remain unchanged

### Requirement: Voice shortcut placement
A microphone shortcut SHALL be rendered at the bottom-right corner of the description text field; tapping it SHALL start the same voice attachment recording flow.

#### Scenario: Mic shortcut visible
- **WHEN** the report details step renders
- **THEN** a mic icon SHALL appear at the bottom-right corner of the description field
- **WHEN** the user taps the mic shortcut
- **THEN** the voice attachment recording flow SHALL start
