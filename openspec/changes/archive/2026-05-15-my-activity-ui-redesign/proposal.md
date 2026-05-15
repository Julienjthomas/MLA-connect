## Why

The My Activity screen needs a visual refresh to match the new design spec: cleaner tab layout, status filter chips (without sort), and a redesigned empty state that mirrors the home screen's action button pattern — report problem at top, then three secondary actions (share idea, suggest improvement, appreciate).

## What Changes

- Remove sort functionality from the Reports tab filter row
- Redesign empty state for all tabs: replace current single-button empty state with a stacked layout — primary "Report a Problem" button on top, then a 3-column action row (Share Idea / Suggest Improvement / Appreciate)
- Empty state keeps the illustration and headline text
- No "Chat with MLA Office" action in empty state (removed per requirement)
- Tab bar retains: Reports, Ideas, Improvements, Appreciations
- Stats/summary card at top retains existing design

## Capabilities

### New Capabilities
- `my-activity-empty-state`: Redesigned empty state with primary CTA + 3 secondary action buttons (no chat)

### Modified Capabilities
- `my-activity`: Remove sort control; update empty state layout per new design

## Impact

- `lib/features/activity/views/activity_view.dart` — remove sort widget, update empty state widget usage
- `lib/core/widgets/empty_state.dart` — extend or replace to support new multi-action layout
