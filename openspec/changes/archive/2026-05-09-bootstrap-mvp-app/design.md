## Context

Greenfield Flutter MVP for civic engagement (citizens ↔ MLA office). Demo/investor-ready quality, must match attached screen mockups, must use Supabase for backend. Single developer, fast turnaround.

## Goals / Non-Goals

**Goals:**
- Pixel-faithful UI from supplied mockups
- All 4 citizen action flows fully navigable
- Real Supabase backend (auth + DB + storage) with mock-data fallback so app runs without DB seed
- Reusable patterns: one master flow controller pattern reused across 4 flows; one feature-color enum; shared step widgets
- Architecture supports adding new screens/flows without touching shell

**Non-Goals:**
- Web/desktop targets (mobile-first; web/macOS run only as a debug convenience)
- Real-time push notifications (deferred)
- Offline write queue (writes require connectivity)
- Localization runtime switching (language stored, single-locale UI for MVP)
- Admin/MLA-side write tooling (read-only for MLA in this app)

## Decisions

### State management: GetX
Chose `get: ^4.6.6` for state + nav + DI in one package. Rejected Riverpod (more boilerplate for MVP), Provider (no built-in nav). Pattern: every controller is a `GetxController` with `Rx`/`Obx` observables; views are `GetView<Controller>`.

### Auth: permanent `AuthController`
Registered with `Get.put(AuthController(), permanent: true)` in `main()` before `GetMaterialApp` so it survives route changes. Holds Supabase session and user profile. All features call `Get.find<AuthController>()`.

### Bottom nav: `IndexedStack`, NOT routes
Tabs are not separate routes. `MainShellView` wraps 4 tab roots in `IndexedStack` driven by `ShellController.currentIndex`. Preserves scroll state, controller state, and OS back-stack semantics. Trade-off: all 4 tab controllers exist in memory simultaneously.

### Multi-step flows: PageView + single controller
Rejected: separate routes per step (back-stack noise, state hand-off complexity). Adopted:
- One `GetxController` per flow owns ALL form state across steps
- `RxInt currentStep` drives `StepperHeader` display
- `PageController` owned by controller; `nextStep()` validates current step then advances
- `PopScope` with `onPopInvokedWithResult` intercepts Android back to call `previousStep()`; at step 0, falls through to `Get.back()`
- Controller scoped to route via binding; destroyed on flow exit
- Same pattern reused across all 4 flows for consistency

### Service layer: controllers depend on services, not Supabase directly
Each feature has a service class (e.g., `ReportService`) that owns `SupabaseClient get _db => Supabase.instance.client` (lazy getter, NOT field initializer — avoids crash if Supabase not yet initialized). Services return models; controllers handle UI state. Enables future swap of backend or test-time mocking.

### Mock-data fallback in services
Every list-fetch service catches errors and returns built-in mock data (e.g., `UpdatesController._mockUpdates`, `MlaModel.placeholder`). App runs end-to-end without a seeded DB. Trade-off: silently masks real backend errors during dev — acceptable for MVP demo, must add error UI before prod.

### Feature-color enum, single source of truth
`FeatureType { report, appreciate, idea, improve }` with extension getters `.color`, `.lightColor`, `.label`, `.subtitle`, `.icon`. Every screen pulls from this — changing report color = one edit. Same pattern for `SubmissionStatus`, `ReportCategory`, `UpdateCategory`, `SubmissionVisibility`, `ActivityTab`.

### `fromString` lives on extension, not enum
Static `fromString` defined inside `extension FooX on Foo` — must be called as `FooX.fromString(...)`. Caught two model bugs at compile time. Document this convention.

### Theming: Material 3 + Poppins
`ThemeData(useMaterial3: true)` with `ColorScheme.fromSeed(seedColor: AppColors.primary)`. Poppins (4 weights) declared in `pubspec.yaml` assets. All colors centralized in `lib/core/theme/app_colors.dart`.

### Routing
Named routes via `Routes.*` constants in `lib/routes/app_routes.dart`. Each `GetPage` in `lib/routes/app_pages.dart` carries its `binding` (DI scope) and `transition: Transition.rightToLeft`.

### Demo mode without Supabase (operational toggle)
For local testing pre-Supabase: change `SupabaseConfig` to skip `Supabase.initialize()` and short-circuit `AuthController.isLoggedIn = true`. Service layer's lazy getters + try/catch fallbacks then exercise the mock paths. Currently NOT in tree (reverted) — design preserves the option.

## Risks / Trade-offs

- [Mock fallback hides backend errors] → Add explicit error states + retry UI before prod; gate fallback on `kDebugMode`
- [Supabase phone OTP not free at scale] → MVP uses provider's free tier; revisit billing before public launch
- [`IndexedStack` keeps all tab state in memory] → 4 tabs is fine; if grows past ~8, switch to lazy `LazyIndexedStack`
- [Single `GetxController` per flow is stateful and bound to route] → Going back mid-flow loses partial input; add a "save draft" snackbar before pop
- [Image upload happens during submit, blocking UX] → Acceptable for MVP; later move to background isolate with progress
- [No tests] → Placeholder widget test only; add golden tests for design-faithful screens before next release
- [`withOpacity` deprecation warnings (~30)] → Cosmetic; migrate to `withValues()` in a polish pass

## Migration Plan

N/A — greenfield baseline.

## Open Questions

- Final Supabase project URL + anon key (placeholder in `supabase_config.dart`)
- Real MLA office data (currently `MlaModel.placeholder`)
- Push notification provider (FCM vs OneSignal vs Supabase Realtime)
- Per-environment config strategy (`.env` + `flutter_dotenv` vs `--dart-define`)
