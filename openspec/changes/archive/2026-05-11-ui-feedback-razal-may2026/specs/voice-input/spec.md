## ADDED Requirements

### Requirement: VoiceInputWidget records and plays back audio
The `VoiceInputWidget` SHALL display a microphone button that records audio when tapped and a playback button once a recording exists.

#### Scenario: Start recording
- **WHEN** the user taps the mic button
- **THEN** recording begins, mic icon changes to stop icon, and a timer shows elapsed seconds

#### Scenario: Stop recording
- **WHEN** the user taps the stop button during recording
- **THEN** recording stops and the audio file path is passed to the parent via `onRecorded` callback

#### Scenario: Playback recorded audio
- **WHEN** a recording exists and the user taps play
- **THEN** the recorded audio plays back via `just_audio`

#### Scenario: Re-record
- **WHEN** the user taps the mic button when a prior recording exists
- **THEN** the prior recording is discarded and a new recording starts

### Requirement: Microphone permission gate
The widget SHALL request microphone permission before starting recording and show an error snackbar if denied.

#### Scenario: Permission denied
- **WHEN** the user denies mic permission
- **THEN** recording does not start and a snackbar says "Microphone permission required"
