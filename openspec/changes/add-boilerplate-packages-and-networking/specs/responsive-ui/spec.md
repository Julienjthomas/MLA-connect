## ADDED Requirements

### Requirement: ScreenUtil initialization
The system SHALL initialize `flutter_screenutil` with a design size at app startup, wrapping the root widget with `ScreenUtilInit`.

#### Scenario: App starts with ScreenUtil configured
- **WHEN** the app launches on any device
- **THEN** `ScreenUtilInit` is initialized with design width 375 and design height 812 (iPhone 13 mini reference)

### Requirement: Responsive sizing extensions available
The system SHALL make ScreenUtil extensions (`.w`, `.h`, `.sp`, `.r`) available throughout the app for responsive sizing.

#### Scenario: Use responsive width
- **WHEN** a widget uses `16.w` for horizontal sizing
- **THEN** the value scales proportionally to the device screen width relative to the 375px design width

#### Scenario: Use responsive font size
- **WHEN** a text widget uses `14.sp` for font size
- **THEN** the font size scales proportionally to the device screen width, maintaining readability across devices
