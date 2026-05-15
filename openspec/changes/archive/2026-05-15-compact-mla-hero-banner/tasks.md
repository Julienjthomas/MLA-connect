## 1. Compact MLA hero widget

- [x] 1.1 Add `kCompactMlaBannerHeight` (80) shared constant on `MlaHeroBanner`
- [x] 1.2 Refactor `mla_hero_banner.dart` to horizontal row: 48px avatar, 15sp single-line name, 80px height, 14px radius
- [x] 1.3 Remove tagline, dot grid, gradient blob, and arc painter from home banner
- [x] 1.4 Keep `GestureDetector` tap → `Routes.mlaDetail` and network photo placeholder

## 2. Home screen integration

- [x] 2.1 Update `home_view.dart` loading placeholder to use `kCompactMlaBannerHeight` (~80px, not 130px)
- [x] 2.2 Verify spacing between banner, Quick actions, and Updates feels balanced (adjust gap only if needed)

## 3. Verification

- [x] 3.1 Manual check on small phone (≤700px height): banner ≤88px, Updates header visible with minimal scroll
- [x] 3.2 Manual check: long MLA name ellipsizes; tap opens MLA detail
- [x] 3.3 Manual check with text scale 1.3: banner does not overflow egregiously (≤96px acceptable)
