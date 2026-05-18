## Context

Asset-only swap. New icons in `/Users/julien/Downloads/AppIcons` follow standard Flutter/native naming for Android (`mipmap-*/ic_launcher.png`) but use raw pixel-size names for iOS (`20.png`, `40.png`, `1024.png`...). Existing iOS `Contents.json` references `Icon-App-<base>x<base>@<scale>x.png` names. To avoid editing `Contents.json` (and Xcode pbxproj indirectly), rename source PNGs to expected names during copy.

## Goals / Non-Goals

**Goals:**
- Replace launcher icons on both platforms.
- Keep existing `Contents.json` unchanged.
- Build runs clean, icon visible on device.

**Non-Goals:**
- Adaptive icons / monochrome icons (Android 13+ themed icon). Source has no foreground/background pair.
- Store listing icons (`appstore.png`, `playstore.png`) — uploaded via console.
- Splash screen, notification icon.

## Decisions

**iOS filename mapping** (source px → target `Icon-App-*`):
- `40.png`  → `Icon-App-20x20@2x.png`, `Icon-App-40x40@1x.png` (iPad)
- `60.png`  → `Icon-App-20x20@3x.png`
- `29.png`  → `Icon-App-29x29@1x.png`
- `58.png`  → `Icon-App-29x29@2x.png`
- `87.png`  → `Icon-App-29x29@3x.png`
- `80.png`  → `Icon-App-40x40@2x.png`
- `120.png` → `Icon-App-40x40@3x.png`, `Icon-App-60x60@2x.png`
- `180.png` → `Icon-App-60x60@3x.png`
- `20.png`  → `Icon-App-20x20@1x.png` (iPad)
- `76.png`  → `Icon-App-76x76@1x.png`
- `152.png` → `Icon-App-76x76@2x.png`
- `167.png` → `Icon-App-83.5x83.5@2x.png`
- `1024.png`→ `Icon-App-1024x1024@1x.png`

Unused source files (`50.png`, `57.png`, `72.png`, `100.png`, `114.png`, `144.png`) — legacy iOS sizes, no slot in current `Contents.json`. Skip.

**Android**: straight copy per density. Source has only `ic_launcher.png` per mipmap — overwrite same name. No `ic_launcher_round.png` in source; leave existing one in place if present (or regenerate from same png if it exists in repo).

**Alternative considered**: rewrite iOS `Contents.json` to reference source's raw-size names. Rejected — touches asset catalog format, riskier than rename-on-copy.

## Risks / Trade-offs

- Round launcher on Android: if `ic_launcher_round.png` exists in repo but no round source provided, will look mismatched → mitigate by copying same `ic_launcher.png` over the round filename or deleting round (manifest fallback).
- Adaptive icon XML (`mipmap-anydpi-v26/ic_launcher.xml`): if present, takes precedence on API 26+ and would ignore the PNG swap → check and remove/update if found.
- Cached icons on device: clear app + reinstall to verify.
