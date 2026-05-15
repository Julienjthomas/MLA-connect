## Why

All four activity tabs (Reports, Ideas, Improvements, Appreciations) show the same generic empty state with a "Report a Problem" primary button, regardless of which tab is active. This creates a confusing UX where a user on the Ideas tab is prompted to report a problem instead of sharing an idea.

## What Changes

- `ActivityEmptyState` widget replaced with tab-aware empty states
- Each tab's empty state shows the relevant CTA and messaging for that tab type
- Reports tab: "Report a Problem" primary CTA (current behavior, retained)
- Ideas tab: "Share an Idea" primary CTA
- Improvements tab: "Suggest an Improvement" primary CTA
- Appreciations tab: "Appreciate Someone" primary CTA

## Capabilities

### New Capabilities
- `tab-aware-empty-state`: Per-tab empty state widget that renders contextual CTA and messaging based on the active activity tab

### Modified Capabilities
- (none — no existing specs are changing requirements)

## Impact

- `lib/core/widgets/activity_empty_state.dart` — modified to accept tab context, or replaced with per-tab variants
- `lib/features/activity/views/activity_view.dart` — each tab passes its type to the empty state
- No API, routing, or data layer changes
