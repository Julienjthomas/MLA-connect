## Context

The MLA Connect citizen app is a Flutter app using GetX for state management, Retrofit+Dio for HTTP, Freezed for models, and Supabase for storage. The current architecture has a clean layered structure: features → controllers → services → Retrofit API clients → Dio. All auth tokens are injected via a Dio interceptor. The app has 15 feature modules, most with shells in place. Key remaining work is wiring existing API client stubs to real endpoints, building screens for missing features, and enforcing business rules the backend defers to the client.

## Goals / Non-Goals

**Goals:**
- Integrate all pending API contracts from the pitch doc into the Flutter app
- Build missing UI screens: notifications center, MLA posts, public events, comments, conversations, leaderboard
- Add account deletion, submission visibility controls, and delete-submission confirmation flows
- Enforce ward cool-off and daily concern limit on the client
- Replace placeholder S3 keys in media uploads with real presigned URL flow

**Non-Goals:**
- Backend changes — all backend APIs are already built (per the pitch doc)
- Admin dashboard — citizen app only
- Push notification delivery infrastructure (only the in-app notification list)
- Offline support or local caching beyond what's needed for app-config

## Decisions

### D1: Media upload — presigned URL flow via service layer

**Decision**: A `MediaUploadService` (or extend existing `SubmissionMediaMerger`) handles the three-step flow: (1) call presigned URL endpoint, (2) PUT file bytes to S3, (3) return `{s3_key, file_name, media_type, display_order}` for inclusion in the submission payload. Controllers call this service before submitting concerns/ideas/appreciations.

**Rationale**: Keeps upload logic in one place. All three submission types share the same flow; a single service avoids duplication across three controllers. The existing `submission_media_access.dart` / `submission_media_merger.dart` pattern already abstracts media — this extends it.

**Alternative considered**: Doing the presigned URL call inside each controller. Rejected because it triples the code and makes testing harder.

### D2: App config — fetched in main before runApp, stored in singleton

**Decision**: At app startup (before `runApp`), call `GET /app-config`, store the result in `AppConfig` (already a singleton). Fall back to hardcoded defaults if the call fails. No retry — just log and continue.

**Rationale**: App config gates feature flags and must be available synchronously after startup. The existing `AppConfig` singleton is the right place. Network failure must not block startup.

**Alternative considered**: Fetching lazily inside controllers. Rejected — feature flags would be unavailable on first render.

### D3: Notifications — polling, not WebSocket

**Decision**: The notifications screen fetches on mount and on pull-to-refresh. No real-time subscription. Mark-as-read is called when the notification list is opened (batch) or on individual tap.

**Rationale**: The API contract (`GET /citizens/notifications` + `PUT /notifications/read`) is REST-only. No WebSocket contract is defined in the pitch doc. Adding polling now and upgrading to WebSocket later is low risk.

### D4: Comments — inline expansion on detail screen, not separate screen

**Decision**: Comments are rendered inline on the concern/idea/appreciation detail screen, behind a "Show comments" toggle. A text field at the bottom allows posting a new comment. Delete requires long-press + confirmation dialog.

**Rationale**: Separate comment screens add navigation depth without value. Inline keeps context visible.

### D5: Conversations — use existing chat feature shell

**Decision**: `lib/features/chat/` already exists with a shell. Wire it to the `conversations_api.dart` + `ConversationService`. Thread list → thread detail → message list with bottom composer.

**Rationale**: The shell is there; avoid creating a parallel structure.

### D6: Ward cool-off — enforced in profile controller, not onboarding

**Decision**: Check cool-off in the profile edit controller when the user attempts to change ward. Show a bottom sheet with days remaining. The onboarding flow (first-time setup) is exempt — cool-off only applies to changes after initial setup.

**Rationale**: First-time onboarding must not be blocked. The profile edit screen is the only post-onboarding entry point for ward changes.

### D7: Daily concern limit — optimistic client check via activity summary

**Decision**: Before opening the concern submission flow, fetch `GET /citizens/activity/summary`. If `total_concerns` in the last 24h ≥ 2, show a blocking dialog with the reset time. The backend is the authority; the client check is UX-only.

**Alternative considered**: Track locally in SharedPreferences. Rejected — out of sync if user submits from another device or if concerns are deleted.

### D8: Leaderboard — read-only screen, rank from constituency summary + citizen profile

**Decision**: Leaderboard is a new screen under home/achievements showing citizens ranked by `contribution_count`. Fetch from a to-be-confirmed endpoint (use `GET /constituencies/:id/summary` data augmented by a leaderboard API if available; otherwise stub with profile contribution count). Badges are computed client-side from contribution thresholds.

**Rationale**: The pitch doc lists leaderboard as low priority. Implement the screen with client-side badge logic now; connect to a real leaderboard API endpoint when the backend adds it.

## Risks / Trade-offs

- **S3 presigned URL expiry**: Presigned URLs expire (typically 15 min). If the user is slow to submit after picking media, the upload may fail. Mitigation: request the presigned URL immediately before upload, not when the user picks the file.
- **Comments pagination on detail screen**: Detail screens load all comments in one call. For high-volume concerns this may be slow. Mitigation: default page_size=20, add "Load more" if needed.
- **Daily concern limit client-side race**: Two rapid submissions may both pass the client check. Mitigation: backend returns an error on the second; show a clear error message and refresh the limit check.
- **Leaderboard endpoint not confirmed**: The backend may not have a `/leaderboard` endpoint yet. Mitigation: gate the screen behind the `app-config` feature flag; stub with `contribution_count` from profile until backend is ready.
- **Conversation real-time**: Chat feels stale with polling only. Trade-off accepted for now; upgrade path is to replace the fetch in the chat controller with a Supabase Realtime subscription (already available via the Supabase SDK in pubspec).

## Open Questions

- Is there a `GET /constituencies/:id/leaderboard` endpoint planned, or should badges be purely client-side from `contribution_count`?
- What is the exact presigned URL endpoint path for concerns, ideas, and appreciations media? (Pitch doc marks them as `[ ] Endpoint to get PreSigned URL` — confirm with backend.)
- Does `DELETE /citizens/:citizenId/account` require the refresh token in body (like logout) or just the bearer token?
