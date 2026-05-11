## Why

The Flutter app's data layer was built against a provisional schema with separate tables (`reports`, `appreciations`, `ideas`, `user_profiles`, `panchayats`). The finalized Supabase schema unifies submissions into a single `submissions` table, renames geography tables, and restructures MLA/staff data. All service and model classes are currently wired to non-existent tables, so live mode will fail completely.

## What Changes

- **BREAKING** Rename `user_profiles` → `profiles`; columns `panchayat_id` → `local_body_id`, `name` → `full_name`
- **BREAKING** Replace `panchayats` table with `local_bodies` (type-discriminated: panchayat/municipality/corporation)
- **BREAKING** Ward FK `panchayat_id` → `local_body_id`; column `number` → `ward_number`
- **BREAKING** Collapse `reports`, `appreciations`, `ideas` tables → unified `submissions` table discriminated by `kind` column
- **BREAKING** Replace `report_media` + `appreciation_media` → `media_attachments` (polymorphic, `attachable_type`/`attachable_id`)
- **BREAKING** Replace `report_timeline` → `submission_status_history`; FK `report_id` → `submission_id`
- **BREAKING** User FK in submissions: `user_id` → `reporter_id`
- **BREAKING** Replace `mla_profile` table → `mlas` table with flat columns + `v_mla_stats` view for stats
- **BREAKING** Notification prefs table: `notification_prefs` → `notification_preferences`
- **BREAKING** Like action: `rpc('increment_likes')` → insert row into `likes` table
- Remove `PanchayatModel`; introduce `LocalBodyModel` with `type` field
- Update `WardModel` to use `ward_number` and `local_body_id`

## Capabilities

### New Capabilities

- `submissions-layer`: Unified read/write for reports, appreciations, and ideas via `submissions` table with `kind` discriminator, `media_attachments` for files, and `submission_status_history` for timeline
- `geography-layer`: Local body and ward data access aligned to `local_bodies` + `wards` schema
- `user-profile-layer`: Profile CRUD aligned to `profiles` table with correct column names
- `mla-layer`: MLA data fetch from `mlas` table + `v_mla_stats` view
- `engagement-layer`: Likes via `likes` table insert/delete; notification prefs via `notification_preferences`

### Modified Capabilities

<!-- No existing specs — this is greenfield alignment -->

## Impact

- `lib/data/models/`: `user_model.dart`, `report_model.dart`, `appreciation_model.dart`, `idea_model.dart`, `mla_model.dart`
- `lib/data/services/`: `user_service.dart`, `report_service.dart`, `appreciation_service.dart`, `idea_service.dart`, `mla_service.dart`, `updates_service.dart`
- `lib/features/auth/controllers/auth_controller.dart` — `saveProfile` column names
- `lib/features/onboarding/controllers/onboarding_controller.dart` — fallback model types
- No UI changes required; all changes are data-layer only
- `DemoConfig.enabled = true` stays as the safe fallback during migration
