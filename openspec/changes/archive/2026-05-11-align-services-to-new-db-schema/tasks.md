## 1. Geography Layer

- [x] 1.1 Add `LocalBodyModel` class to `user_model.dart` with fields `id`, `name`, `type` and `fromJson` factory
- [x] 1.2 Update `WardModel` in `user_model.dart`: rename `panchayatId` → `localBodyId`, `number` → `wardNumber`; update `fromJson` to read `local_body_id` and `ward_number`; update `displayName` getter
- [x] 1.3 Remove `PanchayatModel` class from `user_model.dart`
- [x] 1.4 Update `UserService.getPanchayats` → rename to `getLocalBodies`, query `local_bodies` table, return `List<LocalBodyModel>`
- [x] 1.5 Update `UserService.getWards`: change filter to `.eq('local_body_id', localBodyId)`, order by `ward_number`
- [x] 1.6 Update `OnboardingController`: rename `panchayats`/`selectedPanchayat`/`loadPanchayats`/`selectPanchayat` → `localBodies`/`selectedLocalBody`/`loadLocalBodies`/`selectLocalBody`; update fallback list to `LocalBodyModel`; fix `panchayatSearch` → `localBodySearch`

## 2. User Profile Layer

- [x] 2.1 Update `UserModel` in `user_model.dart`: rename `panchayatId` → `localBodyId`, `panchayatName` → `localBodyName`; update `fromJson` to read `full_name` → `name`, `local_body_id`, `local_bodies.name`; update `toJson` key `name` → `full_name`, `panchayat_id` → `local_body_id`
- [x] 2.2 Update `UserService.getProfile`: query `profiles` (not `user_profiles`); join `local_bodies(name)` (not `panchayats`)
- [x] 2.3 Update `UserService.createProfile` and `updateProfile`: target `profiles` table
- [x] 2.4 Update `UserService.saveNotificationPrefs`: target `notification_preferences` table
- [x] 2.5 Update `AuthController.saveProfile`: use `full_name` key (not `name`), `local_body_id` key (not `panchayat_id`); add `onboarded_at: DateTime.now().toIso8601String()` to upsert data

## 3. MLA Layer

- [x] 3.1 Update `MlaModel.fromJson`: read `full_name` → `name`, `term_label` → `term`; read contact from flat columns (`office_phone`, `office_email`, `office_address`); remove expectation of nested `stats`/`contact` JSON objects
- [x] 3.2 Update `MlaService.getMlaProfile`: query `mlas` table with `.eq('is_current', true).limit(1).single()`; after fetching MLA, query `v_mla_stats` by `mla_id`; merge stats into `MlaModel`
- [x] 3.3 Add `MlaService.getPublicStaff()`: query `mla_staff` with `is_public=true` and `is_active=true`, ordered by `position`

## 4. Submissions Layer — Shared Utilities

- [x] 4.1 Add `_generateReferenceId(String prefix)` helper (e.g. in a `SubmissionUtils` static class or top-level function) that returns `<PREFIX><YYYYMMDD><6-char-random-hex>`

## 5. Submissions Layer — Reports

- [x] 5.1 Update `ReportModel.fromJson`: map `reporter_id` → `userId`; read media from `media_attachments` relation (not `report_media`); read timeline from `submission_status_history` (not `report_timeline`); map `to_status` for timeline status label
- [x] 5.2 Update `ReportFormData.toJson`: rename `user_id` → `reporter_id`; add `kind: 'report'`; add `reference_id` using helper; remove `status` (DB defaults to 'submitted')
- [x] 5.3 Update `ReportService.getMyReports`: query `submissions` with `.eq('kind', 'report').eq('reporter_id', userId)`; join `media_attachments(*)` and `submission_status_history(*)`
- [x] 5.4 Update `ReportService.getReport`: query `submissions` with joins as above
- [x] 5.5 Update `ReportService.submitReport`: insert to `submissions`; insert initial status to `submission_status_history` with `submission_id` and `to_status='submitted'`; insert media to `media_attachments` with `attachable_type='submission'`

## 6. Submissions Layer — Appreciations

- [x] 6.1 Update `AppreciationModel.fromJson`: map `reporter_id` → `userId`; map `target_type` → `recipientCategory`; `recipient_staff_name` → `staffName`; `recipient_department` → `department`; `related_project_name` → `relatedWork`; `description` → `message`; `is_anonymous` → `anonymous`; read media from `media_attachments`
- [x] 6.2 Update `AppreciationFormData.toJson`: rename `user_id` → `reporter_id`; `recipient_category` → `target_type`; `staff_name` → `recipient_staff_name`; `department` → `recipient_department`; `related_work` → `related_project_name`; `message` → `description`; `anonymous` → `is_anonymous`; add `kind: 'appreciation'`; add `reference_id`; remove `status`
- [x] 6.3 Update `AppreciationService.getMyAppreciations`: query `submissions` with `.eq('kind', 'appreciation').eq('reporter_id', userId)`; join `media_attachments(*)`
- [x] 6.4 Update `AppreciationService.submit`: insert to `submissions`; insert media to `media_attachments`

## 7. Submissions Layer — Ideas

- [x] 7.1 Update `IdeaModel.fromJson`: map `reporter_id` → `userId`; `allow_community_discussion` → `allowDiscussion`; `allow_mla_office_contact` → `allowContact`; drop `estimated_resources` (no DB column)
- [x] 7.2 Update `IdeaFormData.toJson`: rename `user_id` → `reporter_id`; `allow_discussion` → `allow_community_discussion`; `allow_contact` → `allow_mla_office_contact`; remove `estimated_resources`; add `kind: 'idea'`; add `reference_id`; remove `status`
- [x] 7.3 Update `IdeaService.getMyIdeas`: query `submissions` with `.eq('kind', 'idea').eq('reporter_id', userId)`
- [x] 7.4 Update `IdeaService.submit`: insert to `submissions`

## 8. Engagement Layer

- [x] 8.1 Update `UpdateModel.fromJson`: map `published_at` → `createdAt`; `cover_image_url` → `imageUrl`
- [x] 8.2 Update `UpdatesService.getUpdates` live query: filter category with `.eq('category', category.dbValue)`; order by `published_at` descending
- [x] 8.3 Update `UpdatesService.likeUpdate`: replace `rpc('increment_likes')` with upsert to `likes` table (`user_id`, `target_type='update'`, `target_id=id`)
- [x] 8.4 Add `UpdatesService.unlikeUpdate(String id)`: delete from `likes` where `user_id=currentUser` and `target_type='update'` and `target_id=id`

## 9. Validation

- [x] 9.1 Run `flutter analyze` and fix all type errors caused by `PanchayatModel` removal and field renames
- [x] 9.2 Verify demo mode still works end-to-end (splash → onboarding → home) with `DemoConfig.enabled = true`
- [x] 9.3 Update `OnboardingController` panchayat view references in [panchayat_view.dart](lib/features/onboarding/views/panchayat_view.dart) and [ward_view.dart](lib/features/onboarding/views/ward_view.dart) to use `localBodies` / `LocalBodyModel`
