## Context

The Flutter MLA Citizen App already uses Supabase (phone OTP, `user_profiles`, `local_bodies`, `wards`, submissions-style services in newer work). Stakeholders want **one binary** serving **Balussery, Koduvalli, and Perambra** assembly constituencies, with **post-login / post-onboarding customization** tied to the citizen’s geography and selected **MLA context**. They also want **citizen → MLA office messaging**, a **simpler home hero**, **long-form complaint/suggestion** entry, **voice on the right with auto-transcription**, and **no language pick during signup** (language in **settings**).

Reference geography (from stakeholders):

- **Assembly constituencies (initial)**: Balussery, Koduvalli, Perambra.
- **Balussery — panchayaths**: Atholi, Balussery, Kayanna, Koorachundu, Kottur, Naduvannur, Panangad, Ulliyeri, Unnikulam (ward counts: 18, 18, 13, 15, 15, 16, 14, 21, 16 → **146** wards estimated).
- **Koduvalli — panchayaths**: Kodenchery, Kizhakkoth, Madavoor, Narikkuni, Omassery, Puduppadi, Thamarassery, Kattippara, Kodanchery, Koduvalli.
- **Perambra — panchayaths**: Arikkulam, Chakkittapara, Changaroth, Cheruvannur, Keezhariyur, Koothali, Meppayur, Nochad, Perambra, Thurayur.

## Goals / Non-Goals

**Goals:**

- Single app build with **runtime constituency context** (assembly constituency → local body → ward) persisted on `user_profiles` (or equivalent) and used to resolve MLA content, labels, and geo-driven pickers.
- **Chat / messaging** UX for authenticated users to reach the MLA office with simple categorization (personal message, request, invitation) and durable server-side storage with RLS.
- **Home** first screen: minimal hero with **MLA photo + name only**; keep existing action tiles/updates patterns unless specs say otherwise.
- **Report + Suggest** flows: **large** in-step text or **optional full-screen composer**; **mic aligned end (right)** in LTR; **automatic speech-to-text** after stop recording into the bound text field, with graceful fallback if transcription fails.
- **Onboarding**: shortest viable path: welcome → phone → OTP → **assembly constituency** → **local body** → **ward** → profile (minimal) → notifications consent (if retained) → home; **no language step** in onboarding.
- **Settings**: user changes **language** here; default locale until changed (device locale or app default—decision below).

**Non-Goals:**

- Office-side **admin/moderator** mobile app (web/console can be separate).
- **Realtime** typing indicators or read receipts in v1 unless trivial with chosen transport.
- Full **offline** chat; optimistic UI optional but not required for v1.
- Automated **ward polygon** map capture.

## Decisions

1. **Constituency data model**  
   - **Decision**: Introduce `assembly_constituencies` (id, name, slug) and relate `local_bodies.assembly_constituency_id` (nullable during migration). Wards remain tied to `local_bodies`.  
   - **Rationale**: Matches real hierarchy; one query path for “panchayaths in this AC”.  
   - **Alternatives**: Enum-only in app (rejected: harder to seed, no SSOT); single flat list (rejected: wrong model).

2. **Seeding / migration**  
   - **Decision**: SQL migration seeds the three ACs and links existing `local_bodies` rows where names match; for new installs, seed full panchayath names per stakeholder lists; ward counts inform validation and QA, not necessarily row counts on day one.  
   - **Rationale**: Aligns DB with product; allows progressive ward row creation.  
   - **Alternatives**: Hard-coded Dart-only lists (rejected for multi-build consistency).

3. **Active MLA resolution**  
   - **Decision**: `mlas` (or current MLA table) rows include `assembly_constituency_id`; client loads MLA by **user’s selected** `assembly_constituency_id`. Home + MLA tab use same resolver.  
   - **Rationale**: Explicit binding per AC.  
   - **Alternatives**: Single MLA row with JSON (rejected: query/RLS pain).

4. **Chat transport**  
   - **Decision**: Postgres-backed `office_messages` (or `mla_messages`) table: `id`, `user_id`, `assembly_constituency_id`, `category` (`personal` | `request` | `invitation` | `other`), `body`, `created_at`, optional `audio_url`, `transcription_status`. List + insert via Supabase client; **Realtime** `postgres_changes` subscription optional in v1.1.  
   - **Rationale**: Fits existing stack, simple RLS, auditable.  
   - **Alternatives**: Third-party chat (rejected: cost, privacy); reuse `submissions` polymorphic kind (possible later convergence; start dedicated for clarity).

5. **Shell navigation for Chat**  
   - **Decision**: Add a **fifth bottom tab** `Chat` (order: Home, Chat, My Activity, Updates, Profile) for discoverability.  
   - **Rationale**: Stakeholder asked for “option within the app”; tab is obvious.  
   - **Alternatives**: FAB on Home (less discoverable); Profile-only entry (hidden).

6. **Language default without onboarding pick**  
   - **Decision**: On first launch use **device locale** if supported; otherwise Malayalam (or existing app default). Persist overrides only when user changes language in **Profile → Language**.  
   - **Rationale**: Removes step while respecting user preference later.

7. **Transcription**  
   - **Decision**: On Android/iOS use platform speech recognition where available (`speech_to_text` or similar); if unavailable or error, show non-blocking snackbar and keep recording attachment path if the flow supports audio.  
   - **Rationale**: Avoids mandatory cloud STT cost for MVP.  
   - **Alternatives**: Server-side STT via Edge Function (good v2 if on-device quality insufficient).

8. **Long-form complaint/suggestion**  
   - **Decision**: Shared `LongFormComposer` pattern: default **≥8 lines** visible `TextField`; overflow menu “Expand” opens **full-screen** route with same controller binding.  
   - **Rationale**: One implementation for Report + Suggest.

## Risks / Trade-offs

- **[Risk] Incomplete ward rows in DB vs stakeholder counts** → **Mitigation**: Treat counts as QA targets; allow demo/static ward lists per local body until DB complete.  
- **[Risk] On-device transcription quality (Malayalam/English mix)** → **Mitigation**: Allow manual edit; show “Transcription may be inaccurate”; optional cloud STT later.  
- **[Risk] Message volume without staff tooling** → **Mitigation**: Email/web hook export or Supabase dashboard filters; rate limit inserts per user if abused.  
- **[Risk] Breaking existing single-constituency assumptions in UI** → **Mitigation**: Feature-flag or staged rollout; grep for hard-coded MLA strings.

## Migration Plan

1. Add `assembly_constituencies` + FK on `local_bodies`; backfill three ACs; link rows.  
2. Extend `user_profiles` with `assembly_constituency_id` (required after onboarding); validate FK.  
3. Deploy message table + RLS (`insert`/`select` own rows; service role for office exports).  
4. Ship app: new onboarding order; settings language; shell tab; chat feature; voice/transcription widget update.  
5. **Rollback**: App version gate; DB migrations reversible via drop FK/column if no dependent production data.

## Open Questions

- Exact **MLA phone** and **office routing** per constituency for `tel:` links.  
- Whether **Share Idea** should reuse the same long-form + voice pattern (recommended for consistency).  
- **Notification** step still required in minimal signup or merged into profile step.  
- **Privacy**: retention period for messages and attachment deletion policy.
