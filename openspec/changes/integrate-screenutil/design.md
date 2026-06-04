## Context

`flutter_screenutil: 5.9.3` is in `pubspec.yaml`. `ScreenUtilInit(designSize: Size(375, 812))` wraps the app in `app.dart`. No UI file currently uses ScreenUtil extensions — all use raw `double` literals. Scope: ~85 widget/view files across `lib/features/`, `lib/core/screens/`, and `lib/core/widgets/`.

## Goals / Non-Goals

**Goals:**
- Every hardcoded pixel value in every widget build method uses the correct ScreenUtil extension
- All files that reference ScreenUtil extensions have the import added
- Consistent extension choice per value type across the entire codebase

**Non-Goals:**
- Changing `ScreenUtilInit` configuration in `app.dart` (already correct)
- Migrating controller, model, or service files (no UI sizing there)
- Changing `AppTextStyles` centrally — font sizes in the style sheet are migrated where they appear inline; the style sheet itself is a separate concern
- Adding new UI or changing any layout behavior

## Decisions

### 1. Extension mapping convention

| Value type | Extension | Example |
|---|---|---|
| Horizontal dimension (width, horizontal padding/margin) | `.w` | `16.w`, `SizedBox(width: 8.w)` |
| Vertical dimension (height, vertical padding/margin) | `.h` | `24.h`, `SizedBox(height: 12.h)` |
| Font size | `.sp` | `fontSize: 14.sp` |
| Border radius, icon size, square containers | `.r` | `BorderRadius.circular(12.r)`, `Icon(size: 22.r)` |
| `EdgeInsets.all()` / `padding: value` (uniform) | `.r` | `EdgeInsets.all(16.r)` |
| `EdgeInsets.symmetric(horizontal:, vertical:)` | `.w` / `.h` | `EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h)` |
| `EdgeInsets.fromLTRB` / `.only` | `.w` left/right, `.h` top/bottom | `EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 0)` |

**Rationale**: Standard ScreenUtil community convention. `.r` for radii/icons keeps them proportional on all screens without distorting on unusual aspect ratios. `.sp` respects device text-scale only when `minTextAdapt: true` (already set).

**Alternative rejected**: Using `.w` for everything — breaks on tall/narrow screens where vertical values would be wrong.

### 2. What NOT to migrate

- `double.infinity` — not a pixel value
- `Duration` milliseconds — not spatial
- `Offset(x, y)` in `BoxShadow` — shadow offsets are intentionally small; ScreenUtil would over-scale them. Keep raw.
- `blurRadius` in `BoxShadow` — same reasoning
- Logical/ratio values (e.g., `alpha: 0.04`, `letterSpacing: 0.8`) — not pixel values
- `strokeWidth`, `elevation` — typically sub-pixel; skip unless large
- `const SizedBox.shrink()` — no dimension to migrate
- `Size.fromHeight(1)` in `PreferredSize` for dividers — 1px separator, intentional

### 3. Migration approach: file-by-file manual edit

Each file is edited directly with precise replacements. An automated regex script would risk false-positive matches (e.g., replacing `1` in `Colors.black54` or `Offset(0, 2)`).

**Alternative rejected**: Regex/codemod script — too many false positives and edge cases in Flutter widget trees.

### 4. Import strategy

Add `import 'package:flutter_screenutil/flutter_screenutil.dart';` to each file that gains ScreenUtil usage. Files already importing it (currently none in features/) get it added once at top.

## Risks / Trade-offs

- **`.r` for `EdgeInsets.all`** — Slightly unusual but matches ScreenUtil docs for "adaptive radius" values. Keeps uniform padding consistent across axes.
  → Mitigation: Document the convention clearly in this design.

- **Scale distortion on tablets** — `splitScreenMode: true` is already set in `ScreenUtilInit`, which handles split-screen. Tablet layouts may still look over-spaced.
  → Mitigation: Out of scope; tablet optimization is a separate concern.

- **Missing a file** — With ~85 files, some may be skimmed.
  → Mitigation: Tasks break work into feature groups; each group is verified by grep after completion.
