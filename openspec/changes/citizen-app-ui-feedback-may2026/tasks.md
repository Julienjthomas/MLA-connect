## 1. Home landing and app bar

- [x] 1.1 Refresh `MlaHeroBanner` with constituency context and stronger visual treatment; keep tap to MLA detail
- [x] 1.2 Rename home Updates section header from `mlaActivity` to localized Updates string
- [x] 1.3 Size home update carousel tiles to ~2.5 visible width with horizontal scroll
- [x] 1.4 Replace bare EN/ML text toggle with icon plus clear target language label; keep persistence behavior

## 2. Voice input widget

- [x] 2.1 Add overlay placement mode on `VoiceInputWidget` for bottom-right in-field mic on multiline fields
- [x] 2.2 Ensure stop-recording invokes `onRecorded` with local path for parent upload flows

## 3. Report problem flow

- [x] 3.1 Move report description voice control to bottom-right inside the description field
- [x] 3.2 Store recorded audio path in `ReportController` and upload on submit; persist `voice_message_url`
- [x] 3.3 Add Visibility step with `SubmissionVisibility` selection before Review; update stepper to four steps
- [x] 3.4 Show selected visibility on Review and include it in submit payload

## 4. Share idea flow

- [x] 4.1 Add overlay `VoiceInputWidget` to idea description on the Details step with dictation append behavior

## 5. Achievements flow

- [x] 5.1 Wire Hall of Excellence FAB to an add-achievement route or flow (remove no-op handler)
- [x] 5.2 Implement add-achievement form validation and success state
- [x] 5.3 Bind listing to data source or structured placeholder; keep empty state when none

## 6. My Activity and Saved

- [x] 6.1 Reduce summary row to four categories: Reports, Ideas, Improvements, Appreciations
- [x] 6.2 Fix duplicate report title when opening report detail from activity list
- [x] 6.3 Remove status timeline section from report detail view
- [x] 6.4 Update Saved tab empty state copy to explain saveable content types; confirm no add FAB on Saved

## 7. Updates engagement

- [x] 7.1 Call `UpdatesService.likeUpdate` / `unlikeUpdate` from `UpdatesController.toggleLike` with optimistic UI rollback on failure
- [x] 7.2 Hydrate `likedIds` on feed load for signed-in users; align `target_type` with live `posts` / `likes` schema
- [x] 7.3 Verify like state on home carousel tiles if likes are shown there

## 8. Localization and verification

- [x] 8.1 Update `app_en.arb` / `app_ml.arb` and regenerate localizations for new or changed strings
- [x] 8.2 Manually verify home, report, idea, activity, achievements, and updates flows on device or emulator

## 9. Product follow-ups (document only)

- [x] 9.1 Record decision on home MLA public programs data source (events posts vs dedicated feed)
- [x] 9.2 Record decision on where public citizen issues and ideas are showcased in the app
