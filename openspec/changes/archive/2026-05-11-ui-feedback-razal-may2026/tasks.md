## 1. Dependencies & Permissions

- [x] 1.1 Add `record` and `just_audio` to `pubspec.yaml` and run `flutter pub get`
- [x] 1.2 Add microphone permission to `AndroidManifest.xml` (`RECORD_AUDIO`)
- [x] 1.3 Add microphone permission to `ios/Runner/Info.plist` (`NSMicrophoneUsageDescription`)
- [x] 1.4 Create `lib/core/constants/geo_constants.dart` with static panchayath and ward lists

## 2. VoiceInputWidget

- [x] 2.1 Create `lib/core/widgets/voice_input_widget.dart` with record/stop/play states using `record` + `just_audio`
- [x] 2.2 Add mic permission request in widget before recording starts
- [x] 2.3 Show snackbar "Microphone permission required" if permission denied
- [x] 2.4 Expose `onRecorded(String filePath)` callback to parent

## 3. Home Page Fixes

- [x] 3.1 In `mla_hero_banner.dart`: remove tick/verified icon, location symbol, and stat counts
- [x] 3.2 In `mla_hero_banner.dart`: reduce banner color intensity (lower opacity or lighter palette)
- [x] 3.3 In `mla_hero_banner.dart`: give "MLA" label a smaller/lighter style vs the MLA name text
- [x] 3.4 In `mla_hero_banner.dart`: nudge MLA name slightly upward for alignment
- [x] 3.5 In `home_view.dart`: increase general font sizes (body ≥14sp, section headers ≥16sp)
- [x] 3.6 In `home_view.dart`: resize four option tiles to fit all on screen without scroll using fractional/Expanded sizing
- [x] 3.7 In `home_view.dart`: reorder tiles to: Report Problem, Share Idea, Suggest Improvement, Appreciate
- [x] 3.8 In `home_view.dart`: change Suggest Improvement tile icon to something distinct from the app logo
- [x] 3.9 In `home_view.dart`: rename "MLA Activity" section label to "Updates"
- [x] 3.10 In `home_view.dart`: wire "View All" button to activate the Updates tab or push updates listing route
- [x] 3.11 In `home_view.dart`: clamp update tile titles to 2 lines with `TextOverflow.ellipsis`
- [x] 3.12 In `home_view.dart`: add `CachedNetworkImage` thumbnail to update tiles; make image tappable → detail
- [x] 3.13 In `home_view.dart`: wrap Hall of Excellence banner in `GestureDetector` → `Get.toNamed(Routes.achievementsListing)`
- [x] 3.14 Fix language toggle: ensure it reads current locale on build (`Obx`/`GetBuilder`) and calls `AppLocale.setLocale` on change
- [x] 3.15 Fix language button alignment issue (use `Row` with proper cross-axis alignment)

## 4. Achievements Listing (stub)

- [x] 4.1 Create `lib/features/achievements/views/achievements_listing_view.dart` with empty state and Add FAB
- [x] 4.2 Add `Routes.achievementsListing` constant and route entry in the app router

## 5. MLA Info Page

- [x] 5.1 In `mla_detail_view.dart`: remove tick/verified icon
- [x] 5.2 In `mla_detail_view.dart`: remove Share action from app bar
- [x] 5.3 In `mla_detail_view.dart`: remove "Third Term" (or any term) badge from hero
- [x] 5.4 In `mla_detail_view.dart`: remove Constituency Initiatives section and its widget
- [x] 5.5 In `mla_detail_view.dart`: remove WhatsApp button from sticky bottom bar
- [x] 5.6 In `mla_detail_view.dart`: wrap About MLA text in an expandable widget (e.g., `ExpansionTile` or custom expand/collapse)
- [x] 5.7 Add nullable `education` and `officeAddress` fields to `MlaModel`
- [x] 5.8 In `mla_detail_view.dart`: render education line in About section when non-null
- [x] 5.9 In `mla_detail_view.dart`: render office address in contact section when non-null
- [x] 5.10 In `mla_detail_view.dart`: nudge MLA name position slightly upward in hero

## 6. Report Problem Page

- [x] 6.1 In `report_details_step.dart`: replace category dropdown/radio with `FilterChip` wrap for all `ReportCategory` values
- [x] 6.2 In `report_details_step.dart`: increase description `maxLength` from 500 to 1500 and show remaining count
- [x] 6.3 In `report_details_step.dart`: set description field `minLines: 5`, `maxLines: 10`
- [x] 6.4 In `report_details_step.dart`: add `DropdownButtonFormField` for Panchayath using `GeoConstants.panchayaths`
- [x] 6.5 In `report_details_step.dart`: add `DropdownButtonFormField` for Ward using `GeoConstants.wards`
- [x] 6.6 In `report_details_step.dart`: remove GPS icon and hint text from any location text field
- [x] 6.7 In `report_details_step.dart`: add `VoiceInputWidget` beside the description field
- [x] 6.8 In `report_details_step.dart`: add media upload cap guard — show snackbar and block if files ≥ 10
- [x] 6.9 In `report_flow_view.dart`: remove the separate Location step from the page flow (merge into Details)
- [x] 6.10 In `report_flow_view.dart`: update stepper to 2 dots (Details, Review)
- [x] 6.11 Remove or leave unused `report_location_step.dart` (no longer rendered)
- [x] 6.12 Remove "Pin on Map" option from the report flow
- [x] 6.13 Remove location option from Gradual Update tab (if present)
- [x] 6.14 Investigate and fix the submit failure in `ReportController.submit()` / `report_service.dart`

## 7. Suggest Improvement Page

- [x] 7.1 In `suggestion_step.dart`: remove GPS icon from any location field (prefix/suffix)

## 8. Submit Appreciation Page

- [x] 8.1 In `visibility_step.dart`: audit options list and remove the duplicate anonymous entry (keep exactly 3 options: public, mlaOnly, anonymous)
- [x] 8.2 In `appreciation_flow_view.dart`: wrap Scaffold in `GestureDetector(onTap: () => FocusScope.of(context).unfocus())` to dismiss keyboard on outside tap

## 9. Share Idea Page

- [x] 9.1 In `idea_details_step.dart`: detect when `selectedTopic == 'Other'`
- [x] 9.2 In `idea_details_step.dart`: conditionally render a `TextField` for custom topic input when "Other" is selected
- [x] 9.3 In `IdeaController`: add `customTopic` field and include it in submission when topic is "Other"
- [x] 9.4 Validate that custom topic field is non-empty before allowing advance when "Other" is selected

## 10. My Activity Page

- [x] 10.1 In `activity_view.dart`: find and remove the calendar icon from the app bar or summary area

## 11. Updates Page

- [x] 11.1 In `UpdatesController`: add `toggleLike(String id)` method with optimistic local toggle + service call
- [x] 11.2 In `updates_view.dart` update cards: add like `IconButton` (outline/filled toggle) showing like count
- [x] 11.3 In `update_detail_view.dart`: remove duplicate Share button/icon (keep exactly one)
- [x] 11.4 In `update_detail_view.dart`: add like button to engagement row

## 12. Smoke Test

- [x] 12.1 Run `flutter analyze` and fix any warnings/errors
- [ ] 12.2 Verify home page: all 4 tiles visible without scroll, correct order, no tick/location/counts on banner
- [ ] 12.3 Verify MLA info page: no tick, no WhatsApp, expandable About, education/address fields, no initiatives
- [ ] 12.4 Verify report flow: 2-step (details+review), chips, big description box, geo dropdowns, voice input, 10-file cap, submit works
- [ ] 12.5 Verify appreciation: 3 distinct visibility options, keyboard dismisses on outside tap
- [ ] 12.6 Verify idea flow: custom topic input appears when "Other" selected
- [ ] 12.7 Verify my activity: no calendar icon
- [ ] 12.8 Verify updates: like toggles work, single share in detail view
- [ ] 12.9 Verify language switch syncs correctly
- [ ] 12.10 Verify Hall of Excellence banner taps → achievements listing stub
