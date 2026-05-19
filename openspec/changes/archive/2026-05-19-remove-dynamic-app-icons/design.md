## Context

Dynamic app icon switching was implemented using a custom MethodChannel (`systems.keyvalue.super_balussery/app_icon`) bridging Flutter to native Android (activity-alias toggling via `PackageManager`) and iOS (`UIApplication.setAlternateIconName`). The feature switches the launcher icon based on the active constituency slug (balussery, koduvalli, perambra). It touches 3 Flutter files, 2 native files, 2 platform manifests/plists, and image assets across both platforms.

## Goals / Non-Goals

**Goals:**
- Remove all dynamic icon code cleanly with no dead imports or residual channel registrations
- Restore a single stable launcher icon on both platforms
- Ensure Android launches correctly without alias state corruption after removal

**Non-Goals:**
- Replacing with any other icon personalization approach
- Changing the default app icon itself
- Modifying constituency selection or auth logic beyond removing icon side-effects

## Decisions

**Remove DefaultAlias, restore LAUNCHER on MainActivity directly**
Android currently has no LAUNCHER intent-filter on `MainActivity` — all launch goes through `DefaultAlias`. Removing the aliases without restoring the intent-filter would make the app unlaunachable. Restore the standard LAUNCHER intent-filter directly on `MainActivity` and remove all four alias entries.

**Delete the service file entirely, don't stub it**
`AppIconService` has no other consumers or tests. Deleting it is cleaner than leaving an empty class. All three call-sites can simply remove the `await AppIconService.*` lines.

**Remove alternate icon assets**
iOS `AlternateIcons/` folder and Android `ic_launcher_balussery/koduvalli/perambra` mipmap directories are only referenced by the removed feature. Delete to reduce app size.

**Debug/profile manifests need no changes**
`android/app/src/debug/AndroidManifest.xml` and `profile/AndroidManifest.xml` already omit alias declarations — they only need changes if they reference aliases, which they don't.

## Risks / Trade-offs

- **Existing installs with non-default alias active**: After app update, Android will have the alias component disabled but it's no longer declared — this is safe; the OS handles missing components gracefully, and the restored LAUNCHER on MainActivity takes over.
- **iOS users with alternate icon set**: After update, `setAlternateIconName(nil)` is no longer called automatically. iOS will keep the alternate icon until the user clears it manually or the OS resets it. Since we're removing the feature, this is acceptable — the icon will revert to default on app reinstall or OS icon cache flush.

## Migration Plan

1. Remove Flutter service and call-sites
2. Remove `AppLifecycleListener.onPause` hook in `main.dart`
3. Restore LAUNCHER intent-filter on `MainActivity` in `AndroidManifest.xml`
4. Remove four activity-alias blocks from `AndroidManifest.xml`
5. Remove MethodChannel handler from `MainActivity.kt`
6. Remove `CFBundleAlternateIcons` from `Info.plist`
7. Remove MethodChannel handler from `AppDelegate.swift`
8. Delete alternate icon asset directories

No database migrations, no server changes, no rollback needed — purely additive deletion.
