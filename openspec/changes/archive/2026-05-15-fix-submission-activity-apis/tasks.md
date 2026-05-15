## 1. Improvement data layer

- [x] 1.1 Refactor `ImprovementService` to read/write `submissions` with `kind='suggestion'`, `reporter_id`, `reference_id` prefix `SG`, and `SubmissionMediaMerger.attachForSubmissions` on list reads
- [x] 1.2 Update `ImprovementModel` / `ImprovementFormData` to map `description`, department, location, landmark, status, and media refs from unified submission rows
- [x] 1.3 Update `ImprovementController.submit` to pass `AuthController.submissionReporterId` and handle submit errors consistently with other flows

## 2. Idea and appreciation list APIs

- [x] 2.1 Align `IdeaService.getMyIdeas` and `AppreciationService.getMyAppreciations` with the report list contract (reporter id filter, `created_at` desc, media merge before `fromJson`)
- [x] 2.2 Confirm `IdeaModel` and `AppreciationModel` parse merged media and bigint ids via existing submission helpers

## 3. My Activity wiring

- [x] 3.1 Extend `ActivityController` to load improvements in parallel with reports, ideas, and appreciations using `submissionReporterId`
- [x] 3.2 Add `ActivityTab.improvements`, set tab controller length to 5, and implement `_ImprovementsTab` with list or `EmptyState`
- [x] 3.3 Add Improvements summary count to `_SummaryCards` and bind totals from the controller

## 4. Verification

- [ ] 4.1 Manual QA: submit improvement, then confirm Improvements tab and summary count update
- [ ] 4.2 Manual QA: confirm Ideas and Appreciations tabs populate for an account with existing `submissions` rows
- [x] 4.3 Run `flutter analyze` on touched activity and submission service files
