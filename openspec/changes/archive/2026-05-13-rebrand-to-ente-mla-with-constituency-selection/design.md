## Context

Current app is a single-constituency citizen engagement platform hardcoded for "Super Balussery". App name, splash, strings, and onboarding copy all reference "Balussery" directly. The `ConstituencyView` exists and already loads constituencies from Supabase, but it sits mid-onboarding (after OTP). Route logic in `SplashController` and `AuthController.resolveOnboardingResumeRoute()` handles resume logic based on profile completeness.

## Goals / Non-Goals

**Goals:**
- Rename app to "Ente MLA" everywhere (splash, app bar, strings, about, success)
- Move constituency selection to before phone auth (first user decision after splash)
- Persist selected constituency in local storage so it survives app restarts before auth
- Display selected constituency name dynamically on splash and home header
- Existing post-auth onboarding (panchayat → ward → profile → notifications) remains unchanged, scoped to selected constituency

**Non-Goals:**
- Allowing constituency change after profile setup is complete (out of scope)
- Multi-constituency admin or MLA-side configuration
- Changing the underlying Supabase data model

## Decisions

### 1. Constituency selection before vs. after auth
Constituency selection moves to **before phone auth** — between welcome and phone screens. This means the selection must be persisted locally (not just in user profile) so it's available when auth hasn't happened yet.

**Chosen**: Store constituency selection in `SharedPreferences` (id + name) on the device. After auth, save it to the user profile as currently done. On splash resume, if constituency is already in profile, skip the picker.

**Alternative considered**: Keep it after OTP — simpler, no local storage needed. Rejected because the user UX requirement is to choose constituency first before committing to phone auth.

### 2. Splash dynamic constituency display
Splash needs to show constituency name before auth. Read from `SharedPreferences` if set, else show generic tagline ("Your MLA. Your Voice.").

**Chosen**: `SplashController` reads local constituency name from prefs and exposes it as observable. `SplashView` binds to it.

### 3. App name "Ente MLA"
All hardcoded "Super Balussery" → "Ente MLA" in:
- `AppStrings.appName`
- `SplashView` RichText
- Native app name: `android/app/src/main/res/values/strings.xml` and `ios/Runner/Info.plist`

Constituency name shown as secondary line (subtitle), not as part of the primary app name.

### 4. Resume routing: constituency not yet selected
`AuthController.resolveOnboardingResumeRoute()` already returns `Routes.constituency` when `profile.constituencyId == null`. No change needed there. The new constituency-before-auth flow only applies to unauthenticated first-time users.

### 5. ConstituencyView reuse
The existing `ConstituencyView` is reused. It needs a mode flag: **pre-auth mode** (saves to prefs, navigates to `Routes.phone`) vs **post-auth mode** (saves to profile, navigates to `Routes.panchayat`). Pass via `Get.arguments` or route parameter.

## Risks / Trade-offs

- **Prefs out of sync with profile**: If user selects constituency before auth but then abandons — prefs has selection but profile doesn't. Mitigation: on auth success, always write prefs constituency to profile before continuing.
- **Android/iOS display name**: Changing native app name requires a new build — won't take effect in hot reload. No functional risk.
- **Existing logged-in users**: Their splash will now show "Ente MLA" with their saved constituency name — no data migration needed since constituency is already in their profile.

## Migration Plan

1. Update `AppStrings` and `SplashView` — safe, no data change
2. Add `SharedPreferences` constituency persistence utility
3. Modify `ConstituencyView` for pre-auth mode
4. Update route order in `WelcomeView` / `SplashController` to inject constituency screen before phone
5. Update native app name strings (Android + iOS)
6. QA: new user flow, returning user flow, resume from mid-onboarding
