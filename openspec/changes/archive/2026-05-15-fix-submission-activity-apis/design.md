## Context

`ReportService` already reads and writes the unified `submissions` table with `reporter_id` (citizen row id from `AuthController.submissionReporterId`), merges `media_attachments` via `SubmissionMediaMerger`, and powers the Reports tab in My Activity. `IdeaService` and `AppreciationService` query `submissions` but still use minimal selects and the same reporter contract; gaps in media merge or id typing can leave Activity lists empty after submit. `ImprovementService` still targets the removed `improvements` table and auth `user_id`, so improvement submits and history never join the unified model. The database stores improvements as `submissions.kind = 'suggestion'` with `reference_id` prefix `SG`, while Storage uses the `improvements/` folder under `submission-objects`.

## Goals / Non-Goals

**Goals:**

- Route improvement submit and list through `submissions` with the same reporter id, media merge, and ordering contract as reports.
- Load ideas and appreciations in My Activity with the same query and parsing path as reports so tabs reflect real data.
- Add an Improvements tab and summary count in My Activity.
- Keep suggest-improvement step UX unchanged; only persistence and activity wiring change.

**Non-Goals:**

- Saved-tab bookmark behavior, office chat, or report detail timeline work.
- New improvement detail screen or staff moderation tools.
- Backfilling legacy `improvements` rows into `submissions` (only new reads/writes use the unified table).

## Decisions

1. **Use `kind = 'suggestion'` for improvements** — Matches `submissions.kind` in schema and existing reference id prefix `SG`. Product copy may still say "improvement"; services filter on `suggestion`.

2. **Reuse the report service pattern** — `ImprovementService` mirrors `ReportService`: `getMyImprovements(reporterId:)`, `SubmissionMediaMerger.attachForSubmissions`, and submit with `reference_id` from `SubmissionUtils.generateReferenceId('SG')`. Map form fields to `description` (suggestion body), `category` or `assigned_department` (department), `pin_address` or `landmark` (location fields) per existing columns.

3. **Pass `submissionReporterId` from flows and Activity** — Improvement submit and Activity load use `AuthController.submissionReporterId`, not auth UUID alone, matching reports.

4. **Extend Activity tabs without removing Saved** — Add `ActivityTab.improvements` between Ideas and Appreciations; set `DefaultTabController` length to 5. Add a summary stat for improvement count (distinct from Thanks/appreciations).

5. **Align idea and appreciation list queries with reports** — Shared select shape where useful, explicit `reporter_id` filter, `created_at` desc, and media merge before `fromJson`.

**Alternatives considered:** Keeping a separate `improvements` table (rejected: schema is unified). Renaming DB kind to `improvement` (rejected: would need migration; `suggestion` is already canonical).

## Risks / Trade-offs

- **[Risk] Historical rows only in legacy `improvements`** → Mitigation: document that only `submissions` rows appear; optional one-off migration is out of scope.
- **[Risk] Field mapping mismatch on suggestion insert** → Mitigation: map to documented `submissions` columns in service tests or manual QA on submit + My Activity list.
- **[Risk] Five scrollable tabs on small screens** → Mitigation: keep `TabBar` `isScrollable: true` if labels overflow; match existing activity styling.

## Migration Plan

1. Ship Dart service/model and Activity UI changes in one release (no DB migration if `submissions` already supports `suggestion`).
2. Verify submit from suggest-improvement flow then My Activity Improvements tab and summary count.
3. Smoke-test Ideas and Appreciations tabs after reporter/media alignment.
4. Rollback: revert client only; no schema rollback required.

## Open Questions

- Whether improvement list items need a detail route in this change or list-only is enough for MVP.
- Exact summary row layout with a fifth metric (replace Office Chat chip vs. horizontal scroll).
