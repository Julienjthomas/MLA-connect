## 1. Dependencies & Tooling

- [x] 1.1 Add `flutter_flavorizr` to `dev_dependencies` in `pubspec.yaml`
- [x] 1.2 Run `flutter pub get`
- [x] 1.3 Create `flavorizr.yaml` at project root with dev/stg/prod flavor definitions (app IDs, names)

## 2. Generate Native Flavor Config

- [x] 2.1 Run `dart run flutter_flavorizr` to generate Android productFlavors and iOS schemes
- [x] 2.2 Verify `android/app/build.gradle.kts` now contains `productFlavors` block for dev/stg/prod
- [x] 2.3 Verify iOS schemes exist in `ios/Runner.xcodeproj` for each flavor

## 3. Rename Android Package

- [x] 3.1 Update `namespace` in `android/app/build.gradle.kts` from `systems.keyvalue.super_balussery` → `com.mlaconnect`
- [x] 3.2 Move `MainActivity.kt` from `systems/keyvalue/super_balussery/` → `com/mlaconnect/` directory
- [x] 3.3 Update `package` declaration in `MainActivity.kt` to `com.mlaconnect`

## 4. Rename iOS Bundle IDs

- [x] 4.1 Update all `PRODUCT_BUNDLE_IDENTIFIER` entries in `ios/Runner.xcodeproj/project.pbxproj` from `systems.keyvalue.superBalussery` → `com.mlaconnect` (flavorizr may handle this — verify)

## 5. Dart Config Infrastructure

- [x] 5.1 Create `lib/core/config/app_flavor.dart` with `enum AppFlavor { dev, stg, prod }`
- [x] 5.2 Create `lib/core/config/app_config.dart` with `AppConfig` class: `flavor`, `supabaseUrl`, `supabaseAnonKey`, `appName`, `debugBanner`, and `init(AppFlavor)` method
- [x] 5.3 Wire all 3 flavors to the same Supabase URL/key from current `SupabaseConfig` (placeholder for future per-env values)

## 6. Flavor Entry Points

- [x] 6.1 Create `lib/main_dev.dart` — calls `AppConfig.init(AppFlavor.dev)`, initializes Supabase, runs `MlaConnectApp`
- [x] 6.2 Create `lib/main_stg.dart` — calls `AppConfig.init(AppFlavor.stg)`, initializes Supabase, runs `MlaConnectApp`
- [x] 6.3 Create `lib/main_prod.dart` — calls `AppConfig.init(AppFlavor.prod)`, initializes Supabase, runs `MlaConnectApp`

## 7. Rename App Class & Remove Legacy main.dart

- [x] 7.1 Rename `SuperBalusseryApp` → `MlaConnectApp` and `_SuperBalusseryAppState` → `_MlaConnectAppState` in `lib/main.dart`
- [x] 7.2 Move the app widget class to `lib/app.dart` (or keep inline in each entry point — per design decision)
- [x] 7.3 Delete `lib/main.dart` once all 3 entry points are verified working
- [x] 7.4 Update `debugShowCheckedModeBanner` in `MlaConnectApp` to read from `AppConfig.debugBanner`

## 8. Update pubspec & Remaining References

- [x] 8.1 Update `pubspec.yaml`: `name: mla_connect`, update description
- [x] 8.2 Grep for any remaining `super_balussery` / `SuperBalussery` / `balussery` in `lib/` and fix (excluding `constituency_seed.dart` data constants which are domain values, not naming)
- [x] 8.3 Update `.iml` filename if present (`super_balussery.iml` → `mla_connect.iml`)

## 9. Verify

- [ ] 9.1 Run `flutter run --flavor dev -t lib/main_dev.dart` — app launches, app name shows "MLA Connect Dev"
- [ ] 9.2 Run `flutter run --flavor stg -t lib/main_stg.dart` — app launches, app name shows "MLA Connect Stg"
- [ ] 9.3 Run `flutter run --flavor prod -t lib/main_prod.dart` — app launches, app name shows "MLA Connect", no debug banner
- [ ] 9.4 Confirm all 3 can be installed side-by-side on a device/emulator
