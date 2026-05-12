## 1. Database and RLS

- [x] 1.1 Add `assembly_constituencies` table with seed rows for Balussery, Koduvalli, Perambra (slug + display name).
- [x] 1.2 Add `assembly_constituency_id` FK to `local_bodies`; backfill links for existing rows; insert/link stakeholder panchayaths per AC.
- [x] 1.3 Add `assembly_constituency_id` to `user_profiles` (required after onboarding); write migration notes for Balussery ward-count QA totals (146).
- [x] 1.4 Create `office_messages` (or agreed name) table with `user_id`, `assembly_constituency_id`, `category`, `body`, timestamps; enable RLS (users insert/select own rows).
- [x] 1.5 Add indexes on `(user_id, created_at desc)` and `(assembly_constituency_id, created_at desc)` for message listing.

## 2. Geography layer (client + services)

- [x] 2.1 Add models/DTOs for `AssemblyConstituencyModel` and extend local body queries to filter by `assembly_constituency_id`.
- [x] 2.2 Implement `getAssemblyConstituencies()` and `getLocalBodies(assemblyConstituencyId)` in the user/geography service with demo fallbacks mirroring live lists.
- [x] 2.3 Wire ward fetching unchanged by `local_body_id` but ensure pickers reset when AC or local body changes.

## 3. Onboarding

- [x] 3.1 Remove language route/step from onboarding navigation map and routes constants.
- [x] 3.2 Add assembly constituency selection UI immediately after OTP; persist selection to profile state before local body step.
- [x] 3.3 Reorder onboarding to: welcome → phone → OTP → AC → local body → ward → profile → notifications → home; update `hasCompletedOnboarding()` gates.
- [x] 3.4 Update splash/partial-onboarding resume logic to jump to the first incomplete step including AC.
- [x] 3.5 Default locale: device locale if supported else app default; stop persisting language during onboarding.

## 4. Profile settings and locale

- [x] 4.1 Implement Profile → Language flow to read/write `user_profiles.language` and hot-reload `GetMaterialApp` locale.
- [x] 4.2 Extend profile header card to show assembly constituency + local body + ward per spec.
- [x] 4.3 Remove/disable any Home app bar language toggle per `shell-navigation` delta.

## 5. Shell, home hero, MLA resolution

- [x] 5.1 Add fifth bottom tab `Chat` with icon/label and route wiring.
- [x] 5.2 Simplify Home MLA hero to photo + name only; strip constituency/MLA label/stat chrome from hero.
- [x] 5.3 Implement MLA resolver that loads MLA by user’s `assembly_constituency_id`; share between Home and MLA profile tab.
- [x] 5.4 Ensure updates/tiles still respect active constituency content where applicable (queries or filters).

## 6. MLA office chat

- [x] 6.1 Create Chat feature module (controller + views): compose, category selector, history list, empty states, error handling.
- [x] 6.2 Implement `OfficeMessagesService` (Supabase insert/list) scoped to user + AC; handle pagination if needed.
- [x] 6.3 Block/guard unauthenticated send; align copy with categories (personal, request, invitation).
- [x] 6.4 (Optional follow-up) Subscribe to Realtime inserts for live history updates.

## 7. Report problem, suggest improvement, voice input

- [x] 7.1 Extract or implement shared `LongFormComposer` behavior: `minLines >= 8`, expand to full-screen route sharing `TextEditingController`.
- [x] 7.2 Update report Details layout: description row with trailing `VoiceInputWidget` on the right (LTR).
- [x] 7.3 Extend `VoiceInputWidget` with `onTranscript`, trailing alignment prop, and post-record STT invocation with error snackbars.
- [x] 7.4 Merge STT text into description/suggestion fields per merge rules; add tests/manual QA checklist for failure paths.
- [x] 7.5 Mirror long-form + voice + transcription behavior on Suggest Improvement flow.

## 8. My Activity integration

- [x] 8.1 Fetch recent office messages for the signed-in user and render rows or a deep link section per spec.
- [x] 8.2 Ensure counts/summary cards remain coherent when messages exist (adjust UI copy if messages are separate from submissions counts).

## 9. Verification

- [x] 9.1 Manual QA matrix across three ACs: panchayath lists match stakeholder names; ward pickers behave after migrations.
- [x] 9.2 Voice + transcription QA on physical Android/iOS devices (permissions, Malayalam/English mix).
- [x] 9.3 Run `flutter analyze`/tests and fix regressions from routing changes.
