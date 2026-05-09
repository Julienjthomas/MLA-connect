## Why

Super Balussery — civic engagement Flutter app for Balussery constituency — was built greenfield with full MVP scope (onboarding, 4 citizen-action flows, 4-tab shell, MLA profile, updates feed). No spec captured the work. Retroactively documenting the shipped surface so future changes have a baseline contract to diff against.

## What Changes

- Capture the as-built MVP as the project baseline spec set
- Onboarding: splash → welcome → language → phone → OTP → panchayat → ward → profile → notifications
- Auth: Supabase phone OTP via permanent `AuthController` GetX service
- Shell: 4-tab `IndexedStack` (Home, My Activity, Updates, Profile) preserving scroll state
- Citizen flows (PageView + single controller pattern): Report Problem (4 steps), Appreciation (5), Share Idea (5), Suggest Improvement (4)
- MLA detail page with collapsing hero, stats, initiatives, Call/WhatsApp CTA
- Updates feed with category filter chips + detail view
- Profile tab with notification toggles, settings tiles, logout
- Service layer (controllers → services → Supabase) with mock-data fallback when DB calls fail
- Design system: Material 3, Poppins, feature accent colors via `FeatureType` enum

## Capabilities

### New Capabilities
- `onboarding`: First-run flow from splash through profile setup before reaching home
- `auth`: Phone OTP authentication and session management via Supabase
- `shell-navigation`: Bottom-nav 4-tab shell with scroll-state preservation
- `report-problem`: Multi-step citizen issue reporting flow with media + location
- `appreciation`: Multi-step flow recognizing government staff/work
- `share-idea`: Multi-step flow proposing constituency ideas
- `suggest-improvement`: Multi-step flow for practical improvements
- `mla-profile`: Read-only MLA detail view with stats, initiatives, contact CTAs
- `updates-feed`: Category-filtered list of MLA posts with detail view
- `my-activity`: User's own submissions across reports/ideas/appreciations/saved tabs
- `profile-settings`: Notification preferences, language, help, logout

### Modified Capabilities
<!-- None — greenfield baseline -->

## Impact

- All code under `lib/` (greenfield)
- Dependencies: `get`, `supabase_flutter`, `flutter_secure_storage`, `pinput`, `cached_network_image`, `shimmer`, `lottie`, `image_picker`, `geolocator`, `dotted_border`, `url_launcher`, `intl`, `permission_handler`
- External: Supabase project (auth + Postgres + Storage); credentials in `lib/data/supabase/supabase_config.dart`
- Demo-mode service layer requires Supabase init — without it, app crashes at first service-class field access (lazy getters mitigate but auth session checks still need init)
- No CI, no tests beyond placeholder widget test
