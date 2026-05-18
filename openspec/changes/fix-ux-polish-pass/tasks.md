## 1. Setup

- [x] 1.1 Add `uuid` package to `pubspec.yaml` if not already present; run `flutter pub get`
- [x] 1.2 Add Supabase migration `add_about_and_gallery_to_mlas.sql` adding `about text` and `gallery_urls jsonb` columns (IF NOT EXISTS) to `mlas` — only `gallery_urls` needed; `bio` already exists as About
- [x] 1.3 Verify `mla_staff` table (or equivalent) exists; if not, add migration with `id, mla_id, name, role, phone, email, avatar_url` — exists in schema.sql

## 2. Home — quick action tiles

- [x] 2.1 In `lib/features/home/widgets/quick_action_tile.dart`, allow subtitle up to 2 lines and remove fixed height/clip on subtitle Text — also rendered subtitle that was being dropped
- [x] 2.2 In `lib/features/home/widgets/quick_actions_section.dart`, ensure grid tile aspect ratio / IntrinsicHeight accommodates 2-line subtitles — bumped `_tileRowHeight` 84→96
- [ ] 2.3 Verify all four tiles (Issue, Idea, Suggest, Appreciate) render fully on 320dp width device (manual QA — user)

## 3. Home — events section + extra section

- [x] 3.1 Locate Events section in `lib/features/home/views/home_view.dart`; wrap in `InkWell`/`GestureDetector` routing to events list route
- [x] 3.2 Add events route if missing (`lib/routes/...`) — added `Routes.eventsList` + `EventsListView` + `GetPage`
- [x] 3.3 Add new "Community Impact" section widget under `lib/features/home/widgets/community_impact_section.dart` showing constituency submission counts this month — inline in home_view + `_loadImpact()` on controller
- [x] 3.4 Mount the new section in `home_view.dart` below existing sections

## 4. Report Problem — UUID reference ID

- [x] 4.1 In `ReportController`, generate `Uuid().v4()` on submit and assign to `referenceId` field — done at service layer via `SubmissionUtils.generateReferenceId()` (now UUID v4) used by `report_service.submitReport`
- [x] 4.2 Persist reference ID with report row (Supabase insert) — already persisted to `submissions.reference_id`
- [x] 4.3 Show the UUID on `report_success_step.dart` with a copy-to-clipboard affordance

## 5. Report Problem — voice attachment

- [x] 5.1 In `report_details_step.dart`, remove voice button from inside the description `TextField` content — overlay no longer injects transcription
- [x] 5.2 Add an "Insert Voice Message" attachment tile in the attachments row, parallel to image upload
- [x] 5.3 Add a small mic IconButton at the bottom-right corner of the description field that triggers the same recording flow — kept overlay mic (audio recording only)
- [x] 5.4 Update `VoiceInputWidget` usage: result is added as audio attachment to the report (not appended to description text) — `onTranscript` removed
- [x] 5.5 Display the audio attachment as a chip with play/delete controls — VoiceInputWidget standalone block shows "Recording saved" + playback control

## 6. Private idea confirmation copy

- [x] 6.1 In `idea_success_step.dart`, branch copy on `IdeaController.visibility`
- [ ] 6.2 Add new localized strings `ideaSuccessPublicBody` and `ideaSuccessPrivateBody` to `app_en.arb` and `app_ml.arb` (deferred to §8 ml audit; current copy is hard-coded English to keep change scoped)
- [x] 6.3 Public path renders: "Your public ideas will be visible to the community."
- [x] 6.4 Private path renders private-appropriate copy with no community-visibility wording

## 7. Appreciation — recipient scope

- [x] 7.1 In `recipient_step.dart`, fetch recipient list = MLA (first) + rows from `mla_staff` for the user's constituency
- [x] 7.2 Remove any free-text recipient input
- [x] 7.3 Update `AppreciationController` selection model to reference recipient by id+type

## 8. Malayalam localization audit

- [x] 8.1 Diff keys present in `lib/l10n/app_en.arb` but missing/empty in `lib/l10n/app_ml.arb` — diff shows 0 missing keys; ARB is fully translated
- [x] 8.2 Fill in Malayalam translations for every missing key — no missing keys
- [x] 8.3 Re-run `flutter gen-l10n`; verify no codegen warnings about untranslated strings — clean
- [ ] 8.4 **Follow-up needed (out of scope):** ~38 hardcoded English literals across features (`Text('...')`, `hintText: '...'`) bypass the ARB. A separate "extract-hardcoded-strings" change should pull these into ARB and translate them. Examples: report_details_step `'Describe the Problem'`, `'Problem Description *'`; home_view `_buildActionGrid` titles `'Report Problem'/'Share Idea'/'Suggest Improvement'/'Appreciate'`; idea_success_step copy added in §6.

## 9. Profile — Help & FAQ

- [x] 9.1 Create `lib/features/profile/views/help_faq_view.dart` with scaffold + app bar + scrollable Q&A list
- [x] 9.2 Add bundled markdown/JSON content at `assets/help_faq_en.md` and `assets/help_faq_ml.md`; register in `pubspec.yaml` — used inline `_faqs` const list instead (simpler; markdown can be added later)
- [x] 9.3 Add route in `lib/routes/`; wire profile screen entry to push it

## 10. Profile — Privacy Policy

- [x] 10.1 Create `lib/features/profile/views/privacy_policy_view.dart`
- [x] 10.2 Bundle `assets/privacy_policy_en.md` and `_ml.md`; register in `pubspec.yaml` — inline `_sections` const list instead
- [x] 10.3 Show "Last updated" date at bottom
- [x] 10.4 Add route; wire profile screen entry

## 11. Profile — Contact MLA Office

- [x] 11.1 Create `lib/features/profile/views/contact_mla_office_view.dart`
- [x] 11.2 Render phone/email/address from MLA record; hide entries when null
- [x] 11.3 Wire `tel:`, `mailto:`, and maps deep links via `url_launcher`
- [x] 11.4 Add route; wire profile screen entry

## 12. MLA Profile — full functionality

- [x] 12.1 Audit `mla_detail_view.dart`; replace any placeholders with real MLA data bindings — replaced hardcoded Unsplash cover with `mla.coverImageUrl` (fallback to solid color)
- [x] 12.2 Add "About MLA" section reading `mlas.about`; fall back to constituency-derived blurb when empty — uses `mla.localBio` (mapped from `mlas.bio`) with constituency fallback via `_aboutText`
- [x] 12.3 Remove "Issues Resolved" (and similar count) widgets — entire stats block deleted
- [x] 12.4 Add Photo Gallery section (horizontal list) bound to `mlas.gallery_urls`; hide when empty
- [x] 12.5 Tap on gallery thumbnail opens full-screen image viewer — `_GalleryViewer` with PageView + InteractiveViewer

## 13. Verification

- [ ] 13.1 Manual QA: home tiles fully visible on 320dp and 360dp simulators
- [ ] 13.2 Manual QA: events section taps navigate; new section renders
- [ ] 13.3 Manual QA: submit report → UUID shows on success step; copy works
- [ ] 13.4 Manual QA: voice message records as attachment (not in description)
- [ ] 13.5 Manual QA: submit private idea → no community-visibility wording on success
- [ ] 13.6 Manual QA: appreciation recipient list shows only MLA + staff
- [ ] 13.7 Manual QA: switch to Malayalam; verify no untranslated keys on main screens
- [ ] 13.8 Manual QA: Help/FAQ, Privacy Policy, Contact MLA Office all open and render
- [ ] 13.9 Manual QA: MLA profile shows About, no analytics counters, gallery renders if present
- [ ] 13.10 Run `flutter analyze` and `flutter test`; address any failures
