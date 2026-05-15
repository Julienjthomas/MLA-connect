## Why

Profile picture upload on the `/profile-setup` screen is completely non-functional. The camera icon button has no tap handler, and the controller has no image picker logic. Users cannot set an avatar during onboarding.

## What Changes

- Wrap the camera icon `Container` in a `GestureDetector` that triggers image selection
- Add `pickAndUploadImage()` method to `ProfileSetupController` using `ImagePicker` + `StorageService`
- Show selected image preview in the `CircleAvatar` before saving
- Pass `avatarUrl` to `AuthController.saveProfile()` on submit
- Fix `StorageService.uploadAvatar()` to use `_imageContentType()` helper instead of inline `'image/$ext'`
- Add loading state during upload and error feedback on failure

## Capabilities

### New Capabilities
- None

### Modified Capabilities
- `user-profile-layer`: Avatar upload now functional during profile setup

## Impact

- `lib/features/auth/views/profile_setup_view.dart` — wrap camera button, show image preview
- `lib/features/auth/controllers/profile_setup_controller.dart` — add image pick/upload logic
- `lib/data/services/storage_service.dart` — fix content type in `uploadAvatar()`
