## Context

Citizen submission flows upload images through `StorageService.uploadSubmissionFiles` before inserting into `submissions` and `media_attachments`. The client uses bucket `submission-objects` with paths `{problems|ideas|improvements|appreciations}/{auth_user_id}/{timestamp}_{filename}` and stores returned public URLs on the submission.

Live Supabase already has bucket `submission-objects` (`public = false`) and several `storage.objects` policies, but citizen INSERT/UPDATE/DELETE policies only allow the prefix `submissions/{submission_id}/…` when a matching non-deleted `submissions` row exists for the signed-in citizen. No policy matches the kind-folder layout the app uses, so uploads fail with RLS `403` before any database write.

`supabase/schema.sql` documents the kind-folder layout but does not define storage policies, so repo and remote policy drift is easy to miss.

## Goals / Non-Goals

**Goals:**

- Allow authenticated citizens to upload submission media to the path layout already implemented in Flutter.
- Preserve staff read/delete access on `submission-objects` and existing public read for objects in that bucket where product policy requires it.
- Encode the storage contract in versioned SQL so future deploys match production.
- Verify report, idea, improvement, and appreciation flows that attach images.

**Non-Goals:**

- Redesigning submission lifecycle (draft rows, upload-after-insert, or moving to private signed URLs only).
- Changing `event-images`, `post-images`, or other buckets.
- Orphan object garbage collection or lifecycle jobs.
- Client refactors unless verification shows a remaining mismatch (for example wrong id in the path segment).

## Decisions

### 1. Align Storage RLS with kind-folder paths (not client upload-after-insert)

**Decision:** Add citizen INSERT (and matching SELECT/UPDATE/DELETE where upsert or replace is needed) policies on `storage.objects` for `bucket_id = 'submission-objects'` where `(storage.foldername(name))[1]` is one of `problems`, `ideas`, `improvements`, `appreciations` and `(storage.foldername(name))[2] = auth.uid()::text`.

**Why:** Matches `StorageService`, `supabase/schema.sql` comments, and upload-before-insert flow. Avoids a two-phase client change and duplicate path conventions.

**Alternative considered:** Upload only under `submissions/{submission_id}/…` after creating the row. Rejected here because it forces API and UX changes and duplicates the documented kind-folder layout.

### 2. Keep existing `submissions/{submission_id}/…` policies

**Decision:** Leave current submission-id-scoped policies in place for staff or legacy paths; add kind-folder policies alongside them.

**Why:** Policies are disjoint by first path segment. Removing submission-id rules could break admin or future flows without fixing the citizen bug.

### 3. Use `auth.uid()` for the second path segment

**Decision:** RLS SHALL compare the second folder segment to `auth.uid()::text`, matching `StorageService` when `userId` is the Supabase auth user id.

**Why:** Upload requests already send a valid `authenticated` JWT; mismatch with `citizens.id` is not the observed failure mode.

**Alternative considered:** Join `citizens` on `user_id = auth.uid()`. Rejected unless verification shows the client passing `citizenRowId` in the path.

### 4. Grant SELECT (and UPDATE if upsert is used) on own kind-folder objects

**Decision:** Citizen SELECT on own kind-folder prefixes; UPDATE (and DELETE if product allows user removal before submit) with the same folder checks. INSERT-only is insufficient if `upsert` or overwrite is enabled later.

**Why:** Supabase storage upsert needs INSERT plus SELECT and UPDATE on the same object scope.

### 5. Record policies in repo SQL, apply via migration workflow

**Decision:** Add storage bucket notes and `storage.objects` policy definitions to `supabase/schema.sql` (or a dedicated migration generated after iteration). Apply to the linked Supabase project with the project migration workflow, then re-check advisors.

**Why:** Comments alone do not enforce RLS; the failure is missing or mismatched remote policies.

## Risks / Trade-offs

- **[Orphan uploads]** Pre-submit files may remain if the user abandons the form → Accept for MVP; optional cleanup later.
- **[Public read on private bucket]** Existing public SELECT on `submission-objects` may expose URLs broadly → Keep current product behavior; revisit signed URLs separately.
- **[Policy drift]** Hand-editing dashboard without repo updates → Mitigate with SQL in repo and migration list checks.
- **[Wrong user id in path]** Client bug using non-auth id → Mitigate with integration test or manual upload using auth uid in segment two.

## Migration Plan

1. Draft new `storage.objects` policies in SQL (citizen kind-folder INSERT/SELECT/UPDATE/DELETE; confirm staff policies unchanged).
2. Apply on the Supabase project; run security advisors.
3. Manual test: authenticated POST to `problems/{auth.uid()}/…` and each submission flow with attachments.
4. Commit SQL to the repo; align `schema.sql` comments with policy names.
5. **Rollback:** Drop new policies; citizen uploads return to blocked state without affecting unrelated buckets.

## Open Questions

- Should citizen DELETE on own kind-folder objects be allowed before submit, or staff-only after submit?
- Should bucket `file_size_limit` or `allowed_mime_types` be set now versus a follow-up hardening change?
