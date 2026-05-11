## Context

super_balussery is a Flutter/GetX civic engagement app. State managed via GetX controllers. Multi-step flows use a step-index pattern within a single `FlowView`. Screens identified: `home_view.dart`, `mla_hero_banner.dart`, `mla_detail_view.dart`, `report_flow_view.dart` + steps, `suggestion_step.dart`, `appreciation_flow_view.dart` + steps, `idea_flow_view.dart` + steps, `activity_view.dart`, `updates_view.dart`, `update_detail_view.dart`.

Changes are purely UI/UX fixes with no new backend APIs required, except: geo dropdowns (Panchayath/Ward) need data, voice recording needs a package, and submit fix may require service-layer debugging.

## Goals / Non-Goals

**Goals:**
- All 8 screens updated per Razal feedback
- Voice input widget reusable across forms
- Submit fix for ReportProblem confirmed working
- Geo dropdowns populated (static data acceptable for now)
- No regressions on existing flows

**Non-Goals:**
- Backend API changes for achievements or geo data
- Real-time GPS / map integration
- Push notifications
- Admin/achievement creation backend

## Decisions

**Category selection — chips not dropdown**
Chips (horizontal scroll or wrap) keep options visible without an extra tap. Dropdown adds friction for a short list. → Use `FilterChip` row/wrap in report_details_step.

**Geo dropdowns — static data**
No geo API confirmed. Use hardcoded `List<String>` for Panchayath and Ward for now; swap to API later without spec change. → Static const lists in a `geo_constants.dart` file.

**Voice input — `record` package**
`record` (pub.dev) is lightweight, works iOS+Android, no heavy native deps. Alternative `flutter_sound` is heavier. → Add `record` + `just_audio` for playback. Wrap in `VoiceInputWidget` stateful widget with record/stop/playback states.

**Inline location on Report Problem**
Remove `report_location_step.dart` as a separate step. Merge Panchayath, Ward, and location description into `report_details_step.dart`. Delete location step file or leave empty and skip in flow index.

**Description limit increase**
500 → 1500 chars. Update `maxLength` on TextField and any model/validation constants.

**Media cap**
Add guard in file picker callback: if `selectedFiles.length >= 10`, show snackbar and block addition.

**Keyboard dismiss**
Wrap root scaffold of affected flows in `GestureDetector(onTap: () => FocusScope.of(context).unfocus())`. Apply to Appreciation and any other flow with text inputs.

**Home page tile sizing**
Use `Expanded` or fixed-height constraints so all 4 tiles fit in `MediaQuery.of(context).size.height` without scroll. Currently likely using large fixed heights — switch to fractional sizing.

**Appreciate tile position**
Reorder the 4 tiles list: Report → Idea → Improve → Appreciate.

**Hall of Excellence routing**
Add `onTap` to the banner widget → `Get.toNamed(Routes.achievementsListing)`. Route and page can be a stub if listing page doesn't exist yet.

**Updates images**
`UpdateModel` may already have an image URL field. If not, add nullable `imageUrl`. Render `CachedNetworkImage` in tile; make image tappable → full-screen viewer or update detail.

**Like action on Updates**
`UpdatesController` needs a `toggleLike(id)` method. Optimistic local toggle + service call. UI: `IconButton` with heart icon.

**Duplicate share in UpdateDetailView**
Audit `update_detail_view.dart` — remove one of the two Share widgets found there.

**MLA expandable About**
Replace static `Text` with `ExpansionTile` or custom expand/collapse with animation.

**About MLA education + office address**
Add fields to `MlaModel` (nullable). Render in expandable About section.

**Anonymous duplicate in Appreciation**
`visibility_step.dart` — audit options list; remove the duplicated anonymous entry.

**Idea "Other" topic custom input**
In `idea_details_step.dart`, show a `TextField` beneath the topic selector when `selectedTopic == 'Other'`. Bind to `controller.customTopic`.

**Language switch sync**
`LanguageView` / language toggle widget — ensure `AppLocale.setLocale` is called and the toggle re-reads current locale on build (use `GetBuilder` or `Obx`).

## Risks / Trade-offs

- Voice recording permissions (mic) → must add to `AndroidManifest.xml` and `Info.plist`; missing these = silent failure on device
- Submit fix for Report: root cause unknown until service layer inspected → may surface backend issues outside this change's scope
- Geo static data will need update when real API available
- Hall of Excellence listing page may not exist → create stub route to avoid crash

## Migration Plan

1. Add `record` and `just_audio` to `pubspec.yaml`; run `flutter pub get`
2. Add mic permissions to platform manifests
3. Implement changes screen-by-screen (see tasks.md)
4. Test on device: voice, submit, media cap, geo dropdowns
5. No data migration needed
