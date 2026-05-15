## 1. Controller & Binding

- [x] 1.1 Create `lib/features/profile/controllers/profile_edit_controller.dart` — extend `GetxController`, pre-populate `nameController`, `emailController`, `avatarUrl` from `AuthController.user.value` in `onInit`
- [x] 1.2 Add `loading` and `uploadingAvatar` `RxBool` state, `pickedImagePath` `RxString`
- [x] 1.3 Implement `pickAndUploadAvatar()` using `ImagePicker` + `StorageService` (mirror `ProfileSetupController.pickAndUploadImage()`)
- [x] 1.4 Implement `save()` — validate form, call `AuthController.updateBasicProfile(updates)`, pop on success, show snackbar on error
- [x] 1.5 Create `lib/features/profile/bindings/profile_edit_binding.dart` — lazy-put `ProfileEditController`

## 2. View

- [x] 2.1 Create `lib/features/profile/views/profile_edit_view.dart` — `GetView<ProfileEditController>`, scaffold with AppBar ("Edit Profile") and Save action button
- [x] 2.2 Add tappable avatar circle: shows current/picked image, upload spinner overlay when `uploadingAvatar`, calls `controller.pickAndUploadAvatar()` on tap
- [x] 2.3 Add name `TextFormField` (required, minLength 2) pre-filled from controller
- [x] 2.4 Add email `TextFormField` (optional, email format) pre-filled from controller
- [x] 2.5 Wrap fields in `Form` with `GlobalKey<FormState>`; Save button calls `controller.save()` with loading state guard

## 3. Routing

- [x] 3.1 Add `static const profileEdit = '/profile/edit';` to `Routes` in `lib/routes/app_routes.dart`
- [x] 3.2 Register `GetPage(name: Routes.profileEdit, page: () => const ProfileEditView(), binding: ProfileEditBinding())` in `AppPages` in `lib/routes/app_pages.dart`

## 4. Wire Edit Button

- [x] 4.1 In `lib/features/profile/views/profile_view.dart` `_UserCard`, change edit `IconButton.onPressed` from `() {}` to `() => Get.toNamed(Routes.profileEdit)`

## 5. Verify

- [ ] 5.1 Hot-reload, tap edit button — confirms navigation to edit screen
- [ ] 5.2 Confirm form pre-populates current user data
- [ ] 5.3 Update name, tap Save — confirms profile view reflects new name
- [ ] 5.4 Pick avatar image — confirms upload progress shows, new avatar previewed
- [ ] 5.5 Save with invalid name (< 2 chars) — confirms validation error, no network call
