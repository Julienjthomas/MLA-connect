## Why

Reports were aligned to the unified `submissions` table with `reporter_id`, media attachment merging, and working My Activity list queries. Ideas, appreciations, and improvements still diverge: improvement submit/list still targets the legacy `improvements` table, and My Activity has no improvements tab or summary count even though citizens can submit improvements from home. Users therefore see empty or missing history for non-report submission types despite successful submits.

## What Changes

- Align `ImprovementService` and `ImprovementModel` with the `submissions` table (`kind = 'improvement'`), including `reporter_id`, generated `reference_id` (`IM` prefix), and `media_attachments` handling consistent with reports.
- Harden idea and appreciation list/detail reads to use the same submission select, media merge, and `reporter_id` contract as reports so Activity tabs populate reliably.
- Extend My Activity with an Improvements tab and summary count sourced from the user's improvement submissions.
- Keep existing four-step suggest-improvement UI; only data layer and activity presentation change.

## Capabilities

### New Capabilities

_None._

### Modified Capabilities

- `submissions-layer`: Add improvement read/write requirements on `submissions` and tighten idea/appreciation list requirements to match the report query and media contract.
- `my-activity`: Require an Improvements tab and summary metric alongside reports, ideas, and appreciations.
- `suggest-improvement`: Require submit to insert into `submissions` with `kind = 'improvement'` instead of the legacy `improvements` table.

## Impact

- `lib/data/services/improvement_service.dart`, `idea_service.dart`, `appreciation_service.dart`
- `lib/data/models/improvement_model.dart` (and related form mapping)
- `lib/features/activity/controllers/activity_controller.dart`, `lib/features/activity/views/activity_view.dart`
- `lib/core/constants/app_enums.dart` (`ActivityTab`)
- `lib/features/improvements/controllers/improvement_controller.dart`
- OpenSpec specs: `submissions-layer`, `my-activity`, `suggest-improvement`
