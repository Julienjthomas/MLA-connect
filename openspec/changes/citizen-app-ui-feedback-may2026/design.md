## Context

The MLA Connect citizen app uses GetX feature modules with Supabase-backed submissions and posts. Recent product review identified UX gaps on the home landing, incomplete submission flows (report voice attachment, missing report visibility, inert achievements FAB), My Activity presentation issues, an undefined Saved tab, and non-persistent update likes. Existing OpenSpec capabilities cover many of these areas but implementation drifted (e.g., home section still labeled "MLA Activity", `UpdatesController.toggleLike` is local-only, report flow uses speech-to-text without uploading `voice_message_url`).

## Goals / Non-Goals

**Goals:**

- Improve home landing comprehension: richer MLA hero, "Updates" labeling, ~2.5 visible horizontal update tiles, clearer language control.
- Complete report and idea voice behaviors and add report visibility selection aligned with `SubmissionVisibility`.
- Implement achievements add/list MVP and clarify Saved tab purpose.
- Simplify My Activity summary to four categories; fix report detail title duplication; hide status timeline for now.
- Persist update likes through `UpdatesService` with hydrated liked state on load.

**Non-Goals:**

- Full public citizen wall or community discussion surfaces for all submission types.
- Backend schema for MLA public programs if no feed API exists (home may reuse mock or posts filtered by events category until API lands).
- Reintroducing report status timeline in this change.
- Search on Updates tab.

## Decisions

1. **Home MLA hero enhancement** — Extend `MlaHeroBanner` with constituency subtitle, optional badge/texture, and maintained tap-through to MLA detail rather than introducing a separate carousel. *Alternative:* full-bleed photo hero only — rejected as inconsistent with multi-constituency branding and existing compact home layout.

2. **Home updates section copy** — Use localized `AppStrings.updates` for the home section header; retire `mlaActivity` on home only. *Alternative:* rename globally — rejected to avoid conflicting with distinct "MLA Activity" concepts elsewhere if added later.

3. **Horizontal tile width** — Compute card width as `(viewportWidth - horizontalPadding) / 2.5` with fixed spacing so roughly 2.5 tiles peek on typical phones. *Alternative:* fixed 150px width — rejected because it does not scale across devices.

4. **Language switcher** — Use `IconButton` or compact chip with translate icon plus target language name (`English` / `മലയാളം`), keeping persistence via `AuthController.updateLanguage` / `AppLocale.change`. *Alternative:* settings-only locale — rejected per home-appbar spec.

5. **Report description voice** — Wrap description `TextField` in a `Stack`; position `VoiceInputWidget` bottom-right inside the field padding. Support `onTranscript` for dictation and `onRecorded` for attachable audio; upload on submit to submission storage and set `voice_message_url`. *Alternative:* side-column mic — rejected per feedback.

6. **Report visibility** — Insert a Visibility step before Review (four steps: Details, Visibility, Review, Success), reusing `SubmissionVisibility` patterns from Share Idea. Persist visibility on the submission row. *Alternative:* visibility only on ideas — rejected per feedback.

7. **Share Idea voice** — Mirror report description stack on `IdeaDetailsStep` with the same widget API. *Alternative:* recording-only without dictation — rejected; parity with report reduces training cost.

8. **Achievements** — MVP: FAB navigates to add form; list reads from API if available else structured local/remote placeholder with success state; empty listing shows CTA. *Alternative:* admin-only achievements — rejected; citizen add is explicit feedback.

9. **My Activity summary** — Show exactly four stats: Reports, Ideas, Improvements, Appreciations. Drop Resolved and Office Chat from the summary row; office chat remains in Chat tab with optional caption. *Alternative:* keep six icons — rejected per feedback.

10. **Report detail** — Single title in body; app bar shows generic "Report Detail" without repeating submission title. Remove `TimelineWidget` block until status history is product-ready. *Alternative:* keep timeline behind feature flag — acceptable fallback if removal causes support confusion.

11. **Saved tab** — Document in empty state that users can save Updates posts and publicly shared ideas (bookmark when implemented); until bookmark API exists, show explanatory copy and no FAB. *Alternative:* hide tab — rejected; tab stays with clarity.

12. **Likes** — `UpdatesController.toggleLike` calls `UpdatesService.likeUpdate` / `unlikeUpdate` with optimistic UI; on load, fetch user's liked post ids. Align `target_type` with live schema (`post` if `posts` table is source). *Alternative:* local-only likes — rejected.

## Risks / Trade-offs

- **[Risk] Posts vs updates table naming mismatch** → Verify Supabase table and `target_type` in implementation; spec delta documents canonical values used in code.
- **[Risk] Voice upload size and RLS** → Reuse `submission-objects` paths and existing Storage policies; surface submit errors on Review.
- **[Risk] Achievements without backend** → Ship UI flow with clear empty/seed behavior; block false success if API missing.
- **[Risk] Removing timeline reduces status transparency** → Restore when `submission_status_history` UX is validated.
- **[Risk] Four summary metrics hide "resolved" count** → Resolved remains visible on individual report cards via `StatusChip`.

## Migration Plan

- Deploy as app release; no data migration for likes if schema already supports `likes` on posts.
- If `target_type` values change, one-time alignment script or dual-read is out of scope unless production data uses conflicting values.
- Rollback: revert client; server rows from new likes or voice URLs remain harmless.

## Open Questions

- **Resolved:** MLA public programs on home use `UpdateCategory.events` posts and the existing grievance card until a dedicated programs feed exists.
- **Resolved:** Public citizen issues and ideas surface in Updates when visibility is public; MLA-only and anonymous submissions stay in My Activity and MLA office workflows.
- Should achievements require moderation before appearing in Hall of Excellence?
