## Why

Stakeholders want one MLA Citizen App for all assembly constituencies in scope, with experience tailored after login by the citizen’s chosen constituency. They also want direct messaging to the MLA office, a calmer home surface, stronger long-form input for complaints and suggestions, improved voice capture and transcription, and a shorter signup path without picking language up front.

## What Changes

- **BREAKING (product scope)**: The app is no longer scoped to a single constituency build; content, MLA identity, and geography pickers are driven by the selected assembly constituency and its local bodies.
- Add **assembly constituency** as a first-class selection (initial list: Balussery, Koduvalli, Perambra), then **panchayath** and **ward** per stakeholder hierarchy; include Balussery panchayath → ward-count reference data for planning (total estimated wards 146).
- After authentication, **customize** feeds, MLA profile/banner, labels, and actionable tiles based on the active constituency (and persisted user geography where applicable).
- Add an in-app **Chat** (or equivalent messaging UX) so any logged-in user can send messages to the MLA office, including **personal messages**, **requests**, and **invitations** (categories or message types to be defined in design).
- **Home**: Keep the first screen simple; **MLA banner shows only the MLA’s name and photo** (no extra stats or heavy chrome on that hero).
- **Complaint / suggestion flows**: Provide a **large** text area for detailed writing **or** a dedicated full-screen composer; align **Suggest improvement** (and any related flows) where they share the same pattern.
- **Voice input**: Place the **voice button on the right**; after recording finishes, **automatically transcribe** speech to text and populate the text field (with permission and error handling as in design).
- **Signup / onboarding**: **Minimal** steps; **remove language selection from signup**; expose **language** later under **app settings** (profile/settings).

## Capabilities

### New Capabilities

- `mla-office-chat`: Citizen-to–MLA-office messaging inside the app (compose, send, optional thread/history), supporting personal messages, requests, and invitations; navigation entry from the shell; backend/realtime approach to be decided in design.

### Modified Capabilities

- `geography-layer`: Add assembly constituency above local bodies; align lists with Balussery, Koduvalli, Perambra and their panchayaths; ward counts / membership rules per constituency; queries and models scoped by selected AC where required.
- `onboarding`: Remove language from the signup path; shorten or reorder steps; require constituency context (AC → panchayath → ward as applicable) before treating onboarding as complete; resume rules updated.
- `profile-settings`: Language selection available in settings (replacing onboarding placement); any copy/tiles affected by chat or constituency switching.
- `shell-navigation`: Simpler home hero (name + photo only); optional fifth tab or prominent entry for chat—exact shell change in design; home content respects active constituency.
- `mla-profile`: Consistency with multi-constituency MLA data (if the MLA tab still exists, it must reflect the active constituency’s MLA without contradicting the simplified home banner).
- `report-problem`: Larger or full-screen description composition; voice control on the **right**; transcription fills description after recording.
- `suggest-improvement`: Same long-form and voice/transcription expectations where this flow mirrors complaint entry.
- `voice-input`: Layout (mic on right), post-record **auto-transcription** behavior, and integration contract for parent forms.
- `my-activity`: Include citizen→office messages (or links to the chat feature) in “my submissions” style lists if product expects a unified activity surface.

## Impact

- **Flutter app**: Onboarding controllers/views, home shell, profile settings, report/suggest flows, shared voice widget, new chat feature module, routing, and localization loading strategy.
- **Supabase / Postgres**: Possible new tables for messages (or reuse of a generic submissions/messages pattern), RLS by constituency and `auth.uid()`, storage for optional voice attachments; seed/migration for `assembly_constituencies`, links to `local_bodies`, and ward metadata aligned with the provided lists.
- **Content / ops**: Per–constituency MLA assets (name, photo, copy), office routing for incoming messages, and moderation/workflow outside the app if needed.
