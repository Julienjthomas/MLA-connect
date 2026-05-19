## MODIFIED Requirements

### Requirement: Language picker bottom sheet respects system insets
The language picker bottom sheet SHALL wrap its content in a `SafeArea` (with `top: false`) so that the sheet content is never obscured by the system navigation bar, home indicator, or other bottom system UI on any device or navigation mode.

#### Scenario: Gesture navigation on Android
- **WHEN** the device uses Android gesture navigation (no visible nav bar buttons)
- **THEN** the bottom sheet content SHALL clear the gesture navigation inset area and not be clipped

#### Scenario: 3-button navigation on Android
- **WHEN** the device uses 3-button Android navigation
- **THEN** the bottom sheet content SHALL clear the navigation bar height

#### Scenario: iPhone with home indicator
- **WHEN** the app runs on an iPhone with a home indicator
- **THEN** the bottom sheet content SHALL clear the home indicator inset

#### Scenario: Device with no bottom inset
- **WHEN** the device reports zero bottom system inset (e.g., older device with physical home button)
- **THEN** the bottom sheet content SHALL display with the same visual layout as before (no extra space added)
