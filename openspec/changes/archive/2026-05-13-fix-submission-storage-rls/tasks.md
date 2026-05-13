## 1. Storage policy analysis

- [x] 1.1 Confirm live `submission-objects` policies only allow `submissions/{submission_id}/…` and reject `problems|ideas|improvements|appreciations/{auth_user_id}/…`
- [x] 1.2 Confirm Flutter upload paths in `StorageService` and report/idea/improvement/appreciation controllers use auth user id as the second segment

## 2. Supabase RLS implementation

- [x] 2.1 Add citizen INSERT policy on `storage.objects` for `submission-objects` kind folders with second segment `auth.uid()::text`
- [x] 2.2 Add matching SELECT and UPDATE policies for the same kind-folder scope (DELETE if pre-submit removal is required)
- [x] 2.3 Verify existing staff and public read policies on `submission-objects` still behave as intended
- [x] 2.4 Run Supabase security advisors after policy changes and resolve new findings

## 3. Schema and migration artifacts

- [x] 3.1 Record `submission-objects` bucket layout and new policies in `supabase/schema.sql` or a generated migration file
- [ ] 3.2 Apply the migration to the linked Supabase project and confirm it appears in migration history

## 4. Verification

- [ ] 4.1 Reproduce the failing upload with an authenticated session to `submission-objects/problems/{auth.uid()}/…` and confirm success after policy deploy
- [ ] 4.2 Submit a report with at least one image end-to-end and confirm `media_attachments` rows reference the uploaded URLs
- [ ] 4.3 Smoke-test idea, improvement, and appreciation uploads under their respective kind folders
- [ ] 4.4 Confirm upload to another user's folder path is rejected

## 5. Client follow-up (only if verification fails)

- [x] 5.1 If uploads still fail, trace `AuthController.userId` vs path segment and align client or policy checks
- [ ] 5.2 Surface Storage RLS failures on the review step with a clear snackbar or error message
