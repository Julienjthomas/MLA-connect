## Why

Citizen-facing review surfaced gaps between intended product behavior and the current Flutter app: the home landing feels plain, several submission flows are incomplete or confusing, engagement actions such as likes do not persist, and key areas (Saved, achievements, public showcase of citizen input) lack clear product definition. Addressing this feedback now improves first-run comprehension, submission completion, and trust before broader rollout.

## What Changes

- **Home landing**: Make the MLA hero banner more visually engaging; rename the home feed section from "MLA Activity" to "Updates"; show horizontally scrollable update tiles with roughly 2.5 tiles visible at once; improve the language switcher affordance and labeling.
- **Report problem**: Place the voice control at the bottom-right inside the description field; persist voice recordings through submission storage; add a visibility option step consistent with other submission flows.
- **Share idea**: Add voice input on the idea description step (dictation and/or attachable recording, aligned with report behavior).
- **Achievements**: Implement the full "Add Achievement" flow and listing behavior (the current FAB is inert).
- **My Activity**: Show four summary category icons with counts; fix duplicate title when opening a raised report; remove the status timeline section from report detail for now.
- **Saved**: Clarify in-product what content users can save and how the tab behaves when empty.
- **Updates**: Wire like actions to persistent engagement storage and reconcile UI state with server data.
- **Product follow-ups (documented, not necessarily implemented in this change)**: Surface MLA public programs/events on home where data exists; document where public citizen issues and ideas are showcased.

## Capabilities

### New Capabilities

- `achievements-flow`: Citizen-facing hall of excellence listing and add-achievement submission flow.

### Modified Capabilities

- `mla-profile`: Home MLA hero banner presentation and optional constituency context on the landing card.
- `home-appbar-language-switcher`: Clearer language toggle design and labeling on the home app bar.
- `updates-feed`: Home section naming, horizontal tile sizing, and persistent like behavior on feed and detail.
- `report-problem`: Description voice control placement, voice attachment on submit, and visibility selection in the flow.
- `voice-input`: Widget placement modes and parent callbacks for transcript vs recorded file attachment.
- `share-idea`: Voice input on the idea details step.
- `my-activity`: Summary row cardinality, report detail title presentation, and removal of timeline from report detail.
- `engagement-layer`: Like/unlike persistence, liked-state hydration, and alignment of target types with the posts/likes schema.

## Impact

- **Flutter UI**: `lib/features/home/`, `lib/features/report/`, `lib/features/ideas/`, `lib/features/achievements/`, `lib/features/activity/`, `lib/features/updates/`, `lib/core/widgets/voice_input_widget.dart`, localization ARB files.
- **Services / data**: `UpdatesService`, report and idea submission services, storage upload for voice notes, optional achievements API or local MVP persistence.
- **OpenSpec**: Delta specs under this change plus updates to archived behavior where home language and updates engagement were previously specified.
