## Purpose

Define Supabase Storage paths and RLS for citizen submission media uploads.

## Requirements

### Requirement: Submission objects bucket layout
The system SHALL store citizen submission media in Supabase Storage bucket `submission-objects` using object keys `{folder}/{auth_user_id}/{filename}` where `folder` is one of `problems`, `ideas`, `improvements`, or `appreciations`, and `auth_user_id` is the authenticated user's `auth.users.id`.

#### Scenario: Report attachment path
- **WHEN** a citizen uploads media for a problem report
- **THEN** the object key starts with `problems/` followed by their auth user id and a unique filename segment

#### Scenario: Non-submission folder rejected
- **WHEN** an authenticated user attempts to upload to `submission-objects/other/{auth_user_id}/file.jpg`
- **THEN** Storage rejects the write with an authorization failure

### Requirement: Citizen upload RLS on submission-objects
Storage RLS on `storage.objects` SHALL allow the `authenticated` role to INSERT objects into bucket `submission-objects` when the first path segment is `problems`, `ideas`, `improvements`, or `appreciations` and the second path segment equals `auth.uid()::text`.

#### Scenario: Authenticated citizen upload succeeds
- **WHEN** a signed-in citizen POSTs a new object to `submission-objects/problems/{auth.uid()}/…` with a valid session
- **THEN** Storage accepts the upload and does not return an RLS violation

#### Scenario: Upload to another user's folder fails
- **WHEN** a signed-in citizen POSTs to `submission-objects/problems/{other_user_id}/…` where `{other_user_id}` is not their auth user id
- **THEN** Storage rejects the upload with an authorization failure

### Requirement: Citizen read and update own submission objects
Storage RLS SHALL allow the `authenticated` role to SELECT and UPDATE (and DELETE when product policy allows pre-submit removal) objects in bucket `submission-objects` under the same kind-folder and `auth.uid()` second-segment rules as INSERT.

#### Scenario: Owner can read uploaded object
- **WHEN** a citizen has uploaded `submission-objects/ideas/{auth.uid()}/photo.jpg`
- **THEN** that citizen can SELECT the object metadata and contents per policy

#### Scenario: Upsert on own object
- **WHEN** a citizen replaces an existing object under their own `problems/{auth.uid()}/…` prefix with upsert enabled
- **THEN** Storage permits the operation without an RLS violation on SELECT or UPDATE

### Requirement: Staff access preserved on submission-objects
Storage RLS SHALL continue to allow staff users (per existing `mla_staff` / staff checks) to SELECT and DELETE objects in bucket `submission-objects` for moderation, without granting staff INSERT into arbitrary citizen kind-folder paths unless explicitly required.

#### Scenario: Staff reads citizen submission media
- **WHEN** an active staff account requests an object in `submission-objects`
- **THEN** staff SELECT is permitted under existing staff policies

### Requirement: Public URL compatibility
When the product uses `getPublicUrl` for submission attachments, bucket `submission-objects` SHALL remain readable via the project's chosen public or authenticated read policy so clients can persist stable URLs on `media_attachments`.

#### Scenario: URL returned after upload
- **WHEN** a citizen upload completes successfully
- **THEN** the public URL returned by the client resolves for read access according to bucket read policies
