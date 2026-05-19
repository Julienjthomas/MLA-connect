## Context

App is in pre-demo polish phase. Stakeholder reviewed flows and produced a punch list across Home, Report, Ideas, Appreciation, Profile, MLA Profile, and Malayalam localization. Most items are UI rendering, copy, routing, or small data-shape fixes — no schema migrations. Existing capabilities (`home-quick-actions`, `report-problem`, `voice-input`, `share-idea`, `appreciation`, `mla-profile`, `profile-settings`, `engagement-layer`) already cover the affected surfaces, so this change deltas them rather than rewriting.

## Goals / Non-Goals

**Goals**
- Eliminate visible truncation/clipping on home quick-action tiles.
- Make Report reference IDs unique, opaque, copyable UUIDs.
- Decouple voice capture from the description text field; attach as a media item like images.
- Make idea confirmation copy honor the user's chosen visibility.
- Restrict appreciation recipients to MLA + staff.
- Ship Help & FAQ, Privacy Policy, Contact MLA Office as real, navigable screens.
- Make MLA profile fully functional with completed About section, no resolved-issues analytics, optional gallery.
- Close gaps in Malayalam translations.

**Non-Goals**
- No redesign of any flow's step structure.
- No new backend tables; reuse existing user/MLA tables.
- No analytics replatform — only removal of one widget on MLA profile.
- Photo gallery is best-effort; can ship as empty-state if no images yet.

## Decisions

**UUID generation for Report Reference ID**
- Use the `uuid` Dart package (v4 random) at submission time inside `ReportController`. Persist the generated ID with the report row.
- Alternative: server-side generated ID — rejected because the UI shows the reference ID on the success step immediately and we want offline-resilient display.

**Voice input as attachment, not inline**
- Move voice-record button out of the description `TextField` and into the attachment row (next to image upload) in `report_details_step.dart`.
- A small mic icon at bottom-right *of the field* remains only as a shortcut to start recording in the attachment panel (user request: "voice input button should be placed at the bottom corner of the description box"). Recording itself produces an audio attachment, not text inlined into the description.
- Alternative: keep speech-to-text inline — rejected; user explicitly wants attachment parity with images.

**Visibility-aware idea success copy**
- `idea_success_step.dart` reads `IdeaController.visibility` and switches between two localized strings (`ideaSuccessPublicBody`, `ideaSuccessPrivateBody`).
- Alternative: always strip community wording — rejected; public ideas legitimately benefit from the community-visibility line.

**Appreciation recipient restriction**
- `recipient_step.dart` shows a curated list: MLA (always first) + staff members tagged `role in ('mla','mla_staff')` from the `mla_staff` table (or equivalent). No free-text recipient.
- Alternative: filter client-side from a broader list — rejected; cleaner to source a dedicated query.

**Help/FAQ, Privacy Policy, Contact MLA Office**
- Each gets its own screen + route under `lib/features/profile/views/`. Content: Help/FAQ + Privacy Policy use static markdown bundled in `assets/`, rendered via existing markdown widget or `Text`. Contact MLA Office reads from MLA profile data (phone/email/address) and exposes `tel:`, `mailto:`, and maps deep links.
- Alternative: webview to a hosted page — rejected for offline + branding consistency, but the markdown can be swapped for remote later.

**MLA profile "About" + analytics removal**
- Source About text from `mlas.about` (extend if missing) or a settings table; fall back to constituency description.
- Delete the "Issues Resolved" widget block from `mla_detail_view.dart`.
- Gallery: add a horizontally scrollable section bound to `mla_photos` (new table) OR a JSON array column on `mlas`. **Decision: JSON array column** to keep this change scoped — gallery is optional and read-only for now.

**Malayalam localization**
- Diff keys in `app_en.arb` vs `app_ml.arb`; fill every missing key. Add lints/CI later (out of scope).

**Home tile description visibility**
- Cause is likely a fixed tile height or `maxLines: 1` + ellipsis on the description in `quick_action_tile.dart`. Fix by allowing 2 lines with adequate height, or switching to intrinsic sizing.

**Tappable Events section + extra section**
- Wrap Events section in `InkWell`/`GestureDetector` routing to events list.
- New section: "Community Impact" strip (counts of reports/ideas/appreciations submitted in constituency this month) — reuses existing submissions data.

## Risks / Trade-offs

- [Layout regression on small screens from increased tile height] → manual check on 360x640 and 320x568 simulators.
- [Existing in-flight reports have non-UUID IDs] → only new submissions use UUID; do not retro-migrate.
- [Static Privacy Policy text drifts from legal source of truth] → keep markdown editable; add a "last updated" footer.
- [`mlas.about` schema change] → if column missing, add via Supabase migration in this change; otherwise read existing column.
- [Malayalam translation accuracy] → mark new strings with `// TODO ml-review` comments; native speaker can audit later.

## Migration Plan

1. Add `uuid` dep if absent.
2. Supabase migration: add `about text` and `gallery_urls jsonb` to `mlas` if missing. Idempotent IF NOT EXISTS.
3. Ship UI changes behind no feature flag — pure incremental UX.
4. Rollback: revert commits; migration columns are nullable and additive (safe to leave).

## Open Questions

- Source of staff list for appreciation: is there an existing `mla_staff` table or should staff be modeled as users with a role flag? (Assumed table exists; verify in implementation.)
- Help & FAQ content: who provides copy? Use placeholder bundled markdown and flag for content owner.
- Gallery image upload UI: out of scope here; read-only display only.
