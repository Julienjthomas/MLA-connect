## Why

After flavourizing the app, `launch.json` still has no `program` (entry point) or `flutterRunAdditionalArgs` (flavor) set. Every run config will fail or default to `lib/main.dart` which no longer exists.

## What Changes

- Add `program` and `flutterRunAdditionalArgs` to each launch config so they target the correct flavor entry point
- Each device gets 3 flavor variants (dev/stg/prod), replacing the single generic config per device
- Total: 12 configs (4 devices × 3 flavors) — or a leaner set if that's too many

## Capabilities

### New Capabilities

- `vscode-launch-configs`: VS Code launch configurations wired to Flutter flavors

### Modified Capabilities

<!-- none -->

## Impact

- `.vscode/launch.json` only
