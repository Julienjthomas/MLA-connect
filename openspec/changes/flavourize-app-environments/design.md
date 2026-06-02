## Context

App was built under the internal codename `super_balussery`. The public product is MLA Connect. Current state: one hardcoded `main.dart`, one `SupabaseConfig` with prod credentials, no environment separation. Manual native config used instead of flutter_flavorizr (TTY requirement).

## Goals / Non-Goals

**Goals:**
- All `super_balussery`/`SuperBalussery` naming gone from source, manifests, and native config
- 3 installable flavors: `dev`, `stg`, `prod` — can coexist on same device
- `AppConfig` as the single source of truth for environment values
- Structure that makes "add real dev/stg Supabase URLs later" a 3-line change

**Non-Goals:**
- Separate Supabase projects per env (out of scope for now)
- CI/CD pipeline changes
- Per-flavor push notification or Firebase config
- Changing any feature behavior

## Decisions

### 1. Manual native config (not flutter_flavorizr)

**Decision:** Hand-craft Android `productFlavors` in `build.gradle.kts` and iOS bundle IDs in `pbxproj` directly.

**Rationale:** flutter_flavorizr requires an attached TTY and is designed for greenfield projects. Existing app config is simpler to edit in-place.

### 2. Separate entry points per flavor

**Decision:** `main_dev.dart`, `main_stg.dart`, `main_prod.dart` — each calls `AppConfig.init(AppFlavor.x)` then `runApp`.

### 3. AppConfig as a singleton initialized at startup

```
AppFlavor enum { dev, stg, prod }

AppConfig {
  static late AppFlavor flavor;
  static late String supabaseUrl;
  static late String supabaseAnonKey;
  static late String appName;
  static late bool debugBanner;

  static void init(AppFlavor f) { ... }
}
```

### 4. App ID scheme

```
prod  →  com.mlaconnect
stg   →  com.mlaconnect.stg
dev   →  com.mlaconnect.dev
```

### 5. Shared app widget in lib/app.dart

`MlaConnectApp` extracted to `lib/app.dart`, imported by all 3 entry points.

## Risks / Trade-offs

- **Package ID change breaks existing installs** → Expected and acceptable — pre-launch rename.
- **`main.dart` removal** → Any CI scripts referencing `-t lib/main.dart` must update.

## Migration Plan

1. Add `flutter_flavorizr` dev dep + `flutter pub get`
2. Create `flavorizr.yaml` (documents flavor intent, not used for generation)
3. Manually update `android/app/build.gradle.kts` with productFlavors
4. Create per-flavor `strings.xml` for app names
5. Move `MainActivity.kt` to `com/mlaconnect/` package
6. Update iOS `project.pbxproj` bundle IDs
7. Create `lib/core/config/app_flavor.dart` + `app_config.dart`
8. Create `lib/app.dart` with `MlaConnectApp`
9. Create `lib/main_dev.dart`, `main_stg.dart`, `main_prod.dart`
10. Delete `lib/main.dart`, update pubspec name

**Rollback:** Git revert. No data migration involved.

## Open Questions

- None blocking. Supabase credentials for real dev/stg envs will be added in a future change.
