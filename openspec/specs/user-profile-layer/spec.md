## Purpose

Define the data layer for user profile operations: queries, model mapping, and persistence.
## Requirements
### Requirement: Profile queries run on profiles table
`UserService` SHALL query the `profiles` table (not `user_profiles`) for all CRUD operations.

#### Scenario: Get profile in live mode
- **WHEN** `getProfile(userId)` is called with `DemoConfig.enabled = false`
- **THEN** query runs on `profiles` table with `.eq('id', userId)`
- **THEN** joined relations use `local_bodies(name)` and `wards(name)` (not `panchayats`)

### Requirement: UserModel maps profiles columns
`UserModel.fromJson` SHALL map `full_name` → `name`, `local_body_id` → `localBodyId`, `local_bodies.name` → `localBodyName`. The field `panchayatId`/`panchayatName` SHALL be renamed to `localBodyId`/`localBodyName`.

#### Scenario: Parse profile from DB
- **WHEN** a JSON row from `profiles` with nested `local_bodies` is passed to `UserModel.fromJson`
- **THEN** `model.name` maps from `full_name`
- **THEN** `model.localBodyId` maps from `local_body_id`
- **THEN** `model.localBodyName` maps from `local_bodies.name`

### Requirement: Profile create/update uses correct columns
`UserService.createProfile` and `updateProfile` SHALL use `full_name` (not `name`) and `local_body_id` (not `panchayat_id`) in the data map passed to Supabase.

#### Scenario: Insert profile row
- **WHEN** `createProfile(data)` is called with a map containing `full_name` and `local_body_id`
- **THEN** upsert to `profiles` table succeeds without column-not-found error

### Requirement: AuthController saveProfile uses new column names
`AuthController.saveProfile` SHALL build the data map with `full_name` instead of `name`, and `local_body_id` instead of `panchayat_id`.

#### Scenario: Save profile after onboarding
- **WHEN** `saveProfile(name: 'Rajan', localBodyId: '<uuid>', wardId: '<uuid>', language: 'ml')` is called
- **THEN** upsert data contains key `full_name` with value `'Rajan'`
- **THEN** upsert data contains key `local_body_id`
- **THEN** `onboarded_at` timestamp is set

### Requirement: Notification preferences use correct table
`UserService.saveNotificationPrefs` SHALL upsert to `notification_preferences` (not `notification_prefs`).

#### Scenario: Save notification preferences
- **WHEN** `saveNotificationPrefs(userId, prefs)` is called in live mode
- **THEN** upsert targets `notification_preferences` table with `user_id` key

### Requirement: Avatar selection during profile setup
The profile setup screen SHALL allow users to pick a photo from their gallery and upload it as their avatar.

#### Scenario: User taps camera button
- **WHEN** the user taps the camera icon on the profile setup screen
- **THEN** the device gallery opens for image selection

#### Scenario: Image preview shown after pick
- **WHEN** the user selects an image from the gallery
- **THEN** the selected image is displayed in the avatar circle immediately

#### Scenario: Upload succeeds
- **WHEN** the image is picked successfully
- **THEN** the image is uploaded to Supabase storage and the returned URL is stored for profile save

#### Scenario: Upload fails
- **WHEN** the upload to Supabase storage fails
- **THEN** a snackbar error is shown and the avatar field remains empty (profile can still be saved without it)

#### Scenario: Profile saved with avatar
- **WHEN** the user submits the profile setup form and an avatar URL was captured
- **THEN** the avatar URL is included in the profile save call

