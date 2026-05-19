## Why

The language picker bottom sheet uses a hardcoded bottom padding of `32px`, which clips content behind the system navigation bar on Android gesture-navigation devices. Wrapping the sheet content in `SafeArea` ensures it respects device bottom insets correctly across all Android nav modes and iPhone home indicator.

## What Changes

- Wrap the language bottom sheet builder content in `SafeArea` (bottom only) so system insets are applied dynamically
- Remove the hardcoded `32` bottom value from the static `EdgeInsets.fromLTRB(24, 16, 24, 32)` — replace with `8` to provide minimal breathing room above `SafeArea`'s inset

## Capabilities

### New Capabilities
<!-- none -->

### Modified Capabilities
- `profile-settings`: Language picker bottom sheet now accounts for system bottom insets via SafeArea wrapping

## Impact

- `lib/features/profile/controllers/profile_controller.dart` — `pickLanguage` method builder
- No API changes, no dependency changes
- Pure UI fix; no state or logic affected
