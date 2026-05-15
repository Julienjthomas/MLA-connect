## Context

Profile view has a non-functional edit button (`onPressed: () {}`). Onboarding already has `ProfileSetupView` + `ProfileSetupController` with avatar upload, name/email form, and `AuthController.saveProfile()`. The edit screen can mirror that pattern without duplicating business logic.

## Goals / Non-Goals

**Goals:**
- Functional edit screen for name, email, avatar reachable from profile view
- Persist changes via existing `AuthController.saveProfile()`
- Reuse `StorageService` for avatar upload (same bucket, same pattern)
- Follow existing GetX controller + binding + route pattern

**Non-Goals:**
- Phone number editing (tied to auth identity, requires re-verification)
- Constituency/ward changes (separate onboarding flow)
- Offline queue / optimistic update

## Decisions

**Separate controller vs reuse ProfileSetupController**
→ New `ProfileEditController`. Setup controller has onboarding-specific next-step logic and loading state tied to that flow. Edit controller pre-populates from current user and has a save-and-pop flow. Keeping them separate avoids coupling.

**Navigation: push vs bottom sheet**
→ Full-screen push (`Get.toNamed(Routes.profileEdit)`). Form has multiple fields + avatar picker; bottom sheet would be cramped and doesn't match app nav patterns.

**Avatar upload timing**
→ Upload immediately on pick (same as setup flow). Shows progress inline. On save, the already-uploaded URL is included in the profile payload.

**Save action**
→ Call `AuthController.saveProfile(name, email, avatarUrl)`. On success, pop screen. On error, show snackbar.

## Risks / Trade-offs

- Stale avatar URL if upload succeeds but final save fails → user sees new avatar in field but server has old URL. Mitigation: show error snackbar, let user retry save (re-upload not needed since URL is stored locally in controller).
- `saveProfile` signature must accept optional email and avatarUrl — verify existing method handles nulls before calling.

## Migration Plan

No data migration needed. New route and files; existing profile data unchanged until user explicitly saves.
