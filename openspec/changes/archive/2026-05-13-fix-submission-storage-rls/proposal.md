## Why

Authenticated citizens cannot attach photos when submitting problems, ideas, improvements, or appreciations. Supabase Storage returns `403 Unauthorized` with `new row violates row-level security policy` on `POST` to `submission-objects`, blocking the report flow at upload time even though the user session is valid.

The Flutter client uploads to `submission-objects/{problems|ideas|improvements|appreciations}/{auth_user_id}/…`, but the live bucket policies only allow writes under `submissions/{submission_id}/…` tied to an existing `submissions` row. That path and lifecycle mismatch rejects every pre-submit upload.

## What Changes

- Add or replace Storage RLS policies on `storage.objects` for bucket `submission-objects` so authenticated users can insert (and read/update/delete their own objects as needed) under the documented kind folders with the second path segment equal to `auth.uid()`.
- Keep staff read/delete access for moderation and existing public read behavior for objects in this bucket where product policy requires it.
- Record the bucket layout and policy rules in repo schema/migration artifacts so local and remote Supabase stay aligned with `StorageService` and submission controllers.
- Verify end-to-end uploads from report, idea, improvement, and appreciation flows without weakening access to other buckets (`event-images`, `post-images`, etc.).

## Capabilities

### New Capabilities

- `submission-storage`: Supabase Storage contract for citizen submission media (bucket name, path layout, RLS for authenticated upload/read, and compatibility with client `getPublicUrl` usage).

### Modified Capabilities

- `submissions-layer`: Require submission media uploads to succeed against the `submission-objects` path convention before `media_attachments` rows are written.
- `report-problem`: Require successful Storage upload for report attachments using the `problems/{auth_user_id}/…` layout (replacing stale `media/reports/` wording in requirements).

## Impact

- Supabase project `submission-objects` bucket and `storage.objects` RLS policies (remote migration).
- `supabase/schema.sql` (or new migration) storage policy definitions and comments.
- `lib/data/services/storage_service.dart` and submission controllers only if verification shows a remaining client-side mismatch (primary fix is server policy alignment).
- Citizen submission flows: report problem, share idea, suggest improvement, appreciation.
