## Context

The app uses GetX + Supabase Flutter. All data access is in service classes under `lib/data/services/`. Models live in `lib/data/models/`. The finalized DB schema (FP1_DB-Design) differs significantly from the provisional schema the services were written against. `DemoConfig.enabled = true` guards all live DB calls, so users see mock data until integration is complete.

Key structural change: the DB unifies `reports`, `appreciations`, and `ideas` into a single `submissions` table discriminated by `kind`. Media attachments are polymorphic via `media_attachments`. This means three separate service classes and three models must converge on one table but remain as separate Dart classes (one per kind) for type safety in the UI.

## Goals / Non-Goals

**Goals:**
- All Supabase table/column references match the FP1 schema exactly
- `DemoConfig.enabled = false` produces correct queries against live DB
- Model `fromJson` / `toJson` map to actual DB column names
- No UI files change (data layer only)
- Demo mode fallback stays fully functional

**Non-Goals:**
- Real-time subscriptions (future work)
- Staff app integration
- Notification push delivery
- Storage bucket wiring for media uploads (StorageService is separate)
- Adding new features beyond schema alignment

## Decisions

### 1. Keep separate model + service classes per submission kind

**Decision:** `ReportModel`, `AppreciationModel`, `IdeaModel` remain separate classes. Each service (`ReportService`, `AppreciationService`, `IdeaService`) queries `submissions` with `.eq('kind', 'report')` etc.

**Why:** UI controllers are typed to specific models. Merging into `SubmissionModel` would cascade changes into every controller and view. The DB schema already uses a discriminator column — we mirror that pattern in Dart with separate classes that share the same underlying table.

**Alternative considered:** Single `SubmissionModel` with nullable fields matching the DB. Rejected — too many nullable fields leak into UI, and existing controllers would need significant refactor.

### 2. `LocalBodyModel` replaces `PanchayatModel`

**Decision:** Delete `PanchayatModel`, introduce `LocalBodyModel` with `id`, `name`, `type` fields. `WardModel` gains `localBodyId` (was `panchayatId`) and `wardNumber` (was `number`).

**Why:** The DB has `local_bodies` with a `type` discriminator. Keeping `PanchayatModel` would mean querying a non-existent table. `OnboardingController` fallback data updates accordingly.

**Alternative:** Keep `PanchayatModel` as a type alias. Rejected — misleading naming, and `local_bodies` query would still need to filter by `type = 'panchayat'`.

### 3. Media attachments via polymorphic `media_attachments` table

**Decision:** `ReportService.submitReport` inserts media to `media_attachments` with `attachable_type = 'submission'`, `attachable_id = submissionId`. Same for `AppreciationService`. `fromJson` reads `media_attachments` relation (not `report_media` / `appreciation_media`).

**Why:** DB dropped the per-kind media tables entirely. Supabase supports querying joined relations by alias.

### 4. MLA service reads flat columns + `v_mla_stats` view

**Decision:** `MlaService.getMlaProfile()` queries `mlas` for profile fields, then separately queries `v_mla_stats` for stats. `MlaModel.fromJson` accepts flat JSON (not nested `stats`/`contact` maps).

**Why:** `mlas` table has flat columns (`office_phone`, `office_email`, etc.). Stats live in a view. Nesting in Dart model was based on old `mla_profile` table that had JSON columns.

### 5. Likes via table insert, not RPC

**Decision:** `UpdatesService.likeUpdate` inserts a row to `likes` table (upsert on conflict ignore). Unlike uses delete.

**Why:** DB has no `increment_likes` RPC — likes are tracked as rows in `likes` table with RLS enforcing one per user. Denormalized `like_count` on `updates` is maintained by DB triggers (not app).

## Risks / Trade-offs

- **Submissions `reference_id` auto-generation** → The DB schema shows `reference_id text not null unique` (e.g., "RP2024001256"). The app must generate this or the DB must default it. Risk: insert fails if not provided. Mitigation: generate client-side with `kind` prefix + timestamp + random suffix until a DB function is added.
- **`v_mla_stats` is a global count** → The view counts all submissions regardless of constituency filter. For single-tenant (Balussery only) this is fine now. Mitigation: document as known limitation.
- **`media_attachments` needs `storage_path`** → The field is `not null` in DB. `StorageService` provides this. Risk: if StorageService isn't called first, insert fails. Mitigation: services require `storagePath` param alongside `url`.
- **Demo mode divergence** → Mock data in services won't be updated to reflect new model shapes (e.g., `LocalBodyModel`). Risk: type errors in demo mode after model changes. Mitigation: update fallback data alongside model changes.

## Migration Plan

1. Update models first (no DB calls change yet)
2. Update service query strings + column maps
3. Update `auth_controller.dart` `saveProfile` to use new column names
4. Update `onboarding_controller.dart` fallback data to `LocalBodyModel`
5. Flip `DemoConfig.enabled = false` in a test environment to validate
6. No DB migrations needed — schema is already the target state

**Rollback:** Revert to `DemoConfig.enabled = true`. No DB changes made by this work.

## Open Questions

- Should `reference_id` be generated client-side or via a Postgres function/trigger? (Recommend trigger — safer for uniqueness)
- Should `media_attachments.storage_path` be nullable temporarily to unblock service integration before StorageService is wired? (Recommend yes, then tighten later)
