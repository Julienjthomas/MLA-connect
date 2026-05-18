## Why

New brand app icon assets delivered in `/Users/julien/Downloads/AppIcons`. Current Android/iOS launcher icons are stale (default/old branding). Need to swap them in before next build.

## What Changes

- Replace Android launcher icons in `android/app/src/main/res/mipmap-*/ic_launcher.png` with new assets from `AppIcons/android/`.
- Replace iOS app icon set in `ios/Runner/Assets.xcassets/AppIcon.appiconset/` with new assets from `AppIcons/Assets.xcassets/AppIcon.appiconset/`, mapping source filenames (sized PNGs like `60.png`, `180.png`) to existing `Icon-App-*@*.png` names referenced by `Contents.json`.
- Keep existing `Contents.json` keys/filenames to avoid Xcode project changes.
- Verify no adaptive icon / foreground+background XML drift in Android; if present, leave intact unless new assets include replacements.

## Capabilities

### New Capabilities
- (none)

### Modified Capabilities
- (none — asset-only swap, no spec-level behavior change)

## Impact

- Files: `android/app/src/main/res/mipmap-{mdpi,hdpi,xhdpi,xxhdpi,xxxhdpi}/ic_launcher.png`, `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-*.png`.
- No code, no deps, no API changes.
- Requires rebuild + reinstall to see new icon on device.
- App Store / Play Store listing icons (`appstore.png`, `playstore.png`) available in source folder but uploaded via store consoles, not in repo.
