## Why

The edit button in the profile view's `_UserCard` widget (line 232) has an empty `onPressed: () {}` — tapping it does nothing. Users cannot update their name, email, or avatar after onboarding, leaving profile data permanently stale.

## What Changes

- Add a `ProfileEditView` screen (new file) with form fields for name, email, and avatar
- Wire the edit button in `_UserCard` to navigate to the new screen
- Add `ProfileEditController` to manage form state and save logic
- Register the route and binding
- Reuse existing `StorageService` for avatar upload and `AuthController.saveProfile()` for persistence

## Capabilities

### New Capabilities

- `profile-edit`: Full edit screen for name, email, and avatar — accessible from profile view edit button, saves changes back to Supabase via AuthController

### Modified Capabilities

- `profile-view-edit-button`: The no-op edit button in `_UserCard` is wired to navigate to `Routes.profileEdit`

## Impact

- New files: `profile_edit_view.dart`, `profile_edit_controller.dart`, `profile_edit_binding.dart`
- Modified: `profile_view.dart` (edit button `onPressed`), `app_routes.dart` (new route constant), `app_pages.dart` (new page + binding)
- Reuses: `StorageService`, `AuthController.saveProfile()`, `ProfileSetupController.pickAndUploadImage()` pattern
- No API changes; no new dependencies
