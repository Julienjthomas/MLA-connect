## ADDED Requirements

### Requirement: Each device has three flavor launch configs
For every device (iPhone Simulator, Android Emulator, macOS, Chrome), there SHALL be three launch configurations: one for `dev`, one for `stg`, one for `prod`.

#### Scenario: Dev config launches dev flavor
- **WHEN** developer selects a `· dev` config and launches
- **THEN** Flutter runs with `--flavor dev` and entry point `lib/main_dev.dart`

#### Scenario: Stg config launches stg flavor
- **WHEN** developer selects a `· stg` config and launches
- **THEN** Flutter runs with `--flavor stg` and entry point `lib/main_stg.dart`

#### Scenario: Prod config launches prod flavor
- **WHEN** developer selects a `· prod` config and launches
- **THEN** Flutter runs with `--flavor prod` and entry point `lib/main_prod.dart`

### Requirement: Config names identify device and flavor
Each config name SHALL follow the pattern `<Device> · <flavor>` (e.g., `iPhone · dev`).

#### Scenario: Name is scannable in VS Code dropdown
- **WHEN** developer opens the Run panel in VS Code
- **THEN** they can identify both the target device and flavor from the config name alone

### Requirement: Device IDs are preserved
Each config SHALL retain the original `deviceId` from the existing `launch.json`.

#### Scenario: iPhone Simulator ID preserved
- **WHEN** iPhone configs are launched
- **THEN** `deviceId` SHALL be `37C97B2C-E0B4-4F58-8452-E97FE06FA8E1`

#### Scenario: Android Emulator ID preserved
- **WHEN** Android configs are launched
- **THEN** `deviceId` SHALL be `emulator-5554`
