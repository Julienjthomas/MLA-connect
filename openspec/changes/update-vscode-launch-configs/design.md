## Context

Flutter VS Code extension uses `launch.json` to know which file to run (`program`) and which flavor to pass (`flutterRunAdditionalArgs`). Without these, pressing F5 fails since `lib/main.dart` is gone.

Current configs: iPhone Simulator, Android Emulator, macOS, Chrome — each a single unnamed generic launch.

## Goals / Non-Goals

**Goals:**
- Every device has working dev/stg/prod launch configs
- Config names clearly identify device + flavor
- One-click launch from VS Code Run panel

**Non-Goals:**
- CI/CD or non-VS Code tooling
- Profile/release build configs

## Decisions

### Config structure per flavor

```json
{
  "name": "iPhone · dev",
  "type": "dart",
  "request": "launch",
  "deviceId": "<id>",
  "program": "lib/main_dev.dart",
  "args": ["--flavor", "dev"]
}
```

`args` passes `--flavor dev` to Flutter. `program` points to the correct entry point.

### 12 configs total (4 devices × 3 flavors)

Grouped by device in the name for readability in VS Code's dropdown.

## Risks / Trade-offs

- Many configs in dropdown — acceptable, names make it scannable
- Device IDs are machine-specific (simulator UUID, emulator port) — already present, just preserved

## Open Questions

- None.
