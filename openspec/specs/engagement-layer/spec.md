## Purpose

Define engagement data layer: likes, update queries, and notification preference persistence.

## Requirements

### Requirement: Like action inserts to likes table
`UpdatesService.likeUpdate` SHALL insert a row into `likes` with `user_id`, `target_type='update'`, `target_id=updateId`. It SHALL use upsert with `onConflict` ignore to be idempotent.

#### Scenario: Like an update
- **WHEN** `likeUpdate(id)` is called in live mode
- **THEN** a row is upserted to `likes` with `target_type='update'` and `target_id=id`
- **THEN** calling again with same id does not produce an error

### Requirement: Unlike action deletes from likes table
`UpdatesService` SHALL expose an `unlikeUpdate(String id)` method that deletes the row from `likes` matching current user + `target_type='update'` + `target_id=id`.

#### Scenario: Unlike an update
- **WHEN** `unlikeUpdate(id)` is called in live mode
- **THEN** matching row deleted from `likes` table

### Requirement: Updates query uses correct columns
`UpdatesService.getUpdates` live-mode query SHALL select from `updates` and filter category using the `category` column. `UpdateModel.fromJson` SHALL map `published_at` (not `created_at`) to `createdAt`, and `cover_image_url` to `imageUrl`.

#### Scenario: Fetch updates filtered by category
- **WHEN** `getUpdates(category: UpdateCategory.development)` is called in live mode
- **THEN** query filters `updates` rows by `category = 'development'`
- **THEN** ordered by `published_at` descending

#### Scenario: Parse update from DB row
- **WHEN** a JSON row from `updates` with `published_at` and `cover_image_url` fields is parsed
- **THEN** `model.createdAt` maps from `published_at`
- **THEN** `model.imageUrl` maps from `cover_image_url`

### Requirement: Notification preferences table name corrected
`UserService.saveNotificationPrefs` SHALL target `notification_preferences` table. The column mapping SHALL include `push_token` and `push_platform` if provided.

#### Scenario: Save notification prefs with token
- **WHEN** `saveNotificationPrefs(userId, {'issue_updates': true, ...})` is called
- **THEN** upsert runs on `notification_preferences` with `user_id` as the conflict key
