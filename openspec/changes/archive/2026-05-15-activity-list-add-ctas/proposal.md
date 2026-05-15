## Why

My Activity submission tabs only expose add shortcuts in empty states. Once a user has items, there is no in-tab way to start another report, idea, improvement, or appreciation without leaving the screen. That blocks repeat submissions and hides flows that already exist on Home.

## What Changes

- Add a tab-specific extended floating action button on My Activity for Reports, Ideas, Improvements, and Appreciations.
- Each FAB opens the matching submission flow route already used by Home and empty-state CTAs.
- Keep existing empty-state primary buttons; FAB is the persistent add affordance when lists have content.
- Do not add a FAB on the Saved tab.

## Capabilities

### New Capabilities

_None._

### Modified Capabilities

- `my-activity`: Require submission tabs to expose a floating add action tied to the active tab's submission flow.

## Impact

- `lib/features/activity/views/activity_view.dart`
- `lib/core/constants/app_enums.dart` (`ActivityTab` route/label helpers if needed)
- `openspec/specs/my-activity/spec.md` (via delta spec)
