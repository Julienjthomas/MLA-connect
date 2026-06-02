## Why

The app still carries its internal codename (`super_balussery`) everywhere — package IDs, class names, pubspec — and has no environment separation. Before adding real backend infrastructure, we need the app renamed to its public identity (`mla_connect`) and wired for 3 flavors (dev/stg/prod) so future Supabase/backend swaps are a config change, not a surgery.

## What Changes

- Remove all `super_balussery` / `SuperBalussery` / `balussery` naming from Dart source, pubspec, Android gradle/Kotlin, and iOS pbxproj
- Rename the app to `mla_connect` with public app name "MLA Connect"
- Add `flutter_flavorizr` as a dev dependency and configure 3 flavors
- Create `AppFlavor` enum and `AppConfig` class to centralize per-flavor values
- Add 3 flavor entry points: `main_dev.dart`, `main_stg.dart`, `main_prod.dart`
- All 3 flavors point to the same Supabase project for now; config structure supports per-env values later
- **BREAKING**: Android package ID changes from `systems.keyvalue.super_balussery` → `com.mlaconnect` (and `.dev`, `.stg` variants)
- **BREAKING**: iOS bundle ID changes from `systems.keyvalue.superBalussery` → `com.mlaconnect`

## Capabilities

### New Capabilities

- `app-flavors`: Flutter flavor configuration (dev/stg/prod) with per-flavor app IDs, names, and config values
- `app-config`: Centralized AppConfig/AppFlavor Dart infrastructure for environment-specific values

### Modified Capabilities

<!-- none — this is infrastructure only, no existing spec-level behavior changes -->

## Impact

- `pubspec.yaml` — name, description
- `lib/main.dart` → replaced by `lib/main_dev.dart`, `lib/main_stg.dart`, `lib/main_prod.dart`
- `lib/data/supabase/supabase_config.dart` — consumed by AppConfig instead of used directly
- `android/app/build.gradle.kts` — namespace, applicationId, productFlavors
- `android/app/src/main/kotlin/` — package path renamed
- `ios/Runner.xcodeproj/project.pbxproj` — bundle identifiers per flavor
- New: `lib/core/config/app_flavor.dart`, `lib/core/config/app_config.dart`
- New: `flavorizr.yaml` at project root
