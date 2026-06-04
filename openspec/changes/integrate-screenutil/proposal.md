## Why

`flutter_screenutil` is already installed (v5.9.3) and `ScreenUtilInit` is configured in `app.dart` with design size `375×812`, but all 85+ UI files still use raw pixel values (`SizedBox(height: 24)`, `fontSize: 16`, `EdgeInsets.all(16)`, `BorderRadius.circular(12)`). This means layouts break on non-iPhone-12-sized devices. The infrastructure is ready; only the migration is missing.

## What Changes

- Add `import 'package:flutter_screenutil/flutter_screenutil.dart'` to every UI file that uses raw sizing
- Replace all hardcoded `SizedBox` dimensions with `.w` / `.h` equivalents
- Replace all `EdgeInsets` pixel values with `.w` / `.h` equivalents
- Replace all `fontSize` values with `.sp`
- Replace all `BorderRadius.circular()` pixel values with `.r`
- Replace explicit `width:` / `height:` values on containers, icons, images with `.w` / `.h` / `.r`
- Leave non-visual values (durations, indices, counts, opacity) unchanged
- Leave `double.infinity` unchanged

## Capabilities

### New Capabilities
- `screenutil-migration`: Systematic replacement of hardcoded pixel values with ScreenUtil responsive extensions across all feature screens, core screens, and shared widgets

### Modified Capabilities
- None — no spec-level behavior changes, purely implementation-level

## Impact

- **Files affected**: ~85 `.dart` files in `lib/features/`, `lib/core/screens/`, `lib/core/widgets/`
- **No dependency changes**: `flutter_screenutil` already in `pubspec.yaml`
- **No `app.dart` changes**: `ScreenUtilInit` already configured correctly
- **No routing/logic changes**: only widget build methods touched
