## 1. Storage Service Fix

- [x] 1.1 In `storage_service.dart`, replace inline `'image/$ext'` in `uploadAvatar()` with `_imageContentType(ext)` call

## 2. Controller

- [x] 2.1 In `profile_setup_controller.dart`, add `StorageService` dependency and `ImagePicker` instance
- [x] 2.2 Add `RxString pickedImagePath` and `RxString avatarUrl` observables
- [x] 2.3 Add `RxBool uploadingAvatar` loading state observable
- [x] 2.4 Implement `pickAndUploadImage()`: open gallery, upload via `StorageService.uploadAvatar()`, store URL, handle errors with snackbar
- [x] 2.5 Pass `avatarUrl` to `auth.saveProfile()` in `next()`

## 3. View

- [x] 3.1 In `profile_setup_view.dart`, wrap the `Stack` (avatar + camera button) in a `GestureDetector` that calls `controller.pickAndUploadImage()`
- [x] 3.2 Show `FileImage` from `pickedImagePath` in `CircleAvatar` when an image is picked (Obx), otherwise keep the placeholder
- [x] 3.3 Show a loading indicator over the avatar while `uploadingAvatar` is true
