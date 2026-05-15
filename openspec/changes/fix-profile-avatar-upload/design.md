## Context

`image_picker: ^1.2.2` is already in pubspec. `StorageService.uploadAvatar()` already exists and works — it just needs the content type bug fixed. `AuthController.saveProfile()` already accepts `avatarUrl`. The entire plumbing is in place; only the controller logic and view wiring are missing.

## Goals / Non-Goals

**Goals:**
- Make avatar selection and upload work end-to-end during profile setup
- Show a preview of the picked image before the user submits

**Non-Goals:**
- Image cropping
- Changing avatar post-onboarding (profile edit screen is separate)
- Camera vs gallery choice dialog (gallery only is fine for now)

## Decisions

**Gallery-only picker** — `ImageSource.gallery` avoids needing camera permission declarations for a feature that's purely optional. Can add camera source later.

**Upload on pick, not on submit** — upload immediately after image is selected so submit is fast. Store the returned URL in an `RxString avatarUrl` on the controller. If upload fails, show snackbar and leave avatar null (profile saves fine without it).

**`RxString? pickedImagePath`** on controller holds local file path for preview. `CircleAvatar` shows `FileImage` when set, placeholder otherwise.

**Fix `uploadAvatar` content type** — replace `'image/$ext'` with `_imageContentType(ext)` call which already handles `jpg→jpeg` and other normalizations.

## Risks / Trade-offs

- Upload before submit means a wasted upload if user abandons the screen. Acceptable given avatar files are small and the bucket has upsert enabled.
- No retry logic on failed upload — user gets a snackbar and can try again by tapping the camera button again.
