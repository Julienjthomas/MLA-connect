## 1. Foundation

- [x] 1.1 `flutter create` project + `pubspec.yaml` deps (get, supabase_flutter, pinput, cached_network_image, shimmer, lottie, image_picker, geolocator, dotted_border, url_launcher, intl, permission_handler, flutter_secure_storage)
- [x] 1.2 Theme: `app_colors.dart`, `app_text_styles.dart`, `app_theme.dart` (Material 3 + Poppins)
- [x] 1.3 `app_enums.dart` (`FeatureType`, `SubmissionStatus`, `ReportCategory`, `SubmissionVisibility`, `UpdateCategory`, `ActivityTab`) with extension getters
- [x] 1.4 `app_strings.dart`, `app_assets.dart`, `validators.dart`, `date_formatter.dart`
- [x] 1.5 Routes skeleton: `app_routes.dart`, `app_pages.dart`
- [x] 1.6 `main.dart` with `Supabase.initialize`, permanent `AuthController`, `GetMaterialApp`

## 2. Core widgets

- [x] 2.1 `PrimaryButton` + `SecondaryButton`
- [x] 2.2 `StatusChip`, `CategoryChip`
- [x] 2.3 `ActionCard` (home grid)
- [x] 2.4 `StepperHeader` (multi-step flows)
- [x] 2.5 `EmptyState`, `ShimmerCard`
- [x] 2.6 `ActivityCard`
- [x] 2.7 `UploadWidget` (dotted border + image_picker)
- [x] 2.8 `TimelineWidget`, `KeralaAppBar`

## 3. Data layer

- [x] 3.1 `supabase_config.dart` (placeholder URL/key)
- [x] 3.2 Models: `user_model`, `report_model`, `appreciation_model`, `idea_model`, `improvement_model`, `update_model`, `mla_model` (with `MlaModel.placeholder`)
- [x] 3.3 Services with **lazy** `SupabaseClient get _db` getters: `auth_service`, `report_service`, `appreciation_service`, `idea_service`, `improvement_service`, `updates_service`, `mla_service`, `storage_service`, `user_service`
- [ ] 3.4 Run Supabase schema migrations (panchayats, wards, user_profiles, reports + media + timeline, appreciations + media, ideas, improvements, updates, mla_profile, saved_items)
- [ ] 3.5 Seed reference data (panchayats, wards) + MLA profile row
- [ ] 3.6 Create Supabase Storage bucket `media` (public read), folders reports/, appreciations/, ideas/, avatars/

## 4. Auth & onboarding

- [x] 4.1 `AuthController` with `isLoggedIn`, `userId`, `sendOtp`, `verifyOtp`, `hasCompletedOnboarding`, `saveProfile`, `logout`
- [x] 4.2 Splash view with 2s animation + route decision
- [x] 4.3 Welcome view
- [x] 4.4 Language picker
- [x] 4.5 Phone view + OTP view (pinput, resend timer, +91 prefix)
- [x] 4.6 Panchayat picker, Ward picker (with mock fallback)
- [x] 4.7 Profile setup view
- [x] 4.8 Notifications setup view
- [x] 4.9 Onboarding success view

## 5. Shell & home

- [x] 5.1 `ShellController` (`RxInt currentIndex`)
- [x] 5.2 `MainShellView` with `IndexedStack` + 4-tab `NavigationBar`
- [x] 5.3 `ShellBinding` registers all 4 tab controllers
- [x] 5.4 `HomeView`: SliverAppBar, MLA hero banner, 2×2 action grid, activity feed, Hall of Excellence, grievance event card

## 6. Action flows (master pattern)

- [x] 6.1 `ReportController` master pattern (PageView + currentStep + nextStep validation + PopScope back)
- [x] 6.2 `ReportFlowView` + 4 step widgets (details, location, review, success)
- [x] 6.3 `AppreciationController` + 5-step flow (recipient, message, visibility, review, success)
- [x] 6.4 `IdeaController` + 5-step flow (details, impact, visibility, review, success)
- [x] 6.5 `ImprovementController` + 4-step flow (suggestion, location, review, success)
- [x] 6.6 PageView appBar fix: wrap conditional `Obx` in `PreferredSize` (kToolbarHeight)

## 7. Activity, Updates, MLA, Profile tabs

- [x] 7.1 `ActivityController` + `ActivityView` (4 sub-tabs + summary cards)
- [x] 7.2 `UpdatesController` (with `_mockUpdates` fallback) + `UpdatesView` + `UpdateDetailView`
- [x] 7.3 `MlaController` + `MlaDetailView` (collapsing hero + stats + initiatives + Call/WhatsApp CTA)
- [x] 7.4 `ProfileController` + `ProfileView` (user card, notification switches, settings tiles, logout dialog)

## 8. Verification

- [x] 8.1 `flutter pub get`
- [x] 8.2 `flutter analyze` clean (0 errors)
- [x] 8.3 VSCode `launch.json` configs (iOS sim, Android emulator, macOS, Chrome)
- [ ] 8.4 First boot on a device — verify splash → welcome routing
- [ ] 8.5 End-to-end manual test: complete full onboarding with real OTP
- [ ] 8.6 Manual test: each of 4 flows submits to Supabase
- [ ] 8.7 Manual test: bottom nav preserves scroll across tabs

## 9. Polish (Phase 12)

- [ ] 9.1 Add shimmer skeletons to all async-loading lists (Home activity feed, MLA detail, Activity tabs)
- [ ] 9.2 `Get.snackbar` feedback on all submit actions (success + failure)
- [ ] 9.3 Back-navigation confirmation dialog when half-filled flow forms have unsaved input
- [ ] 9.4 Visual consistency pass against attached mockups (spacing, weights, colors)
- [ ] 9.5 Migrate `withOpacity()` → `withValues()` to clear deprecation warnings
- [ ] 9.6 Replace deprecated `activeColor` on Switches with `activeThumbColor`
- [ ] 9.7 Verify no overflow on iPhone SE (small) and Pixel 7 Pro (large) screen sizes
