## Context

`ActionCard` is a shared widget used on the home screen in a 2×2 grid. Currently it renders icon + title + subtitle on a plain white card. The reference design shows cards with: a colored circular icon at top, title + underline accent + subtitle in the upper half, and a background illustration image fading into the card bottom with a circular arrow CTA.

The updates feed (`_activityCard`) shows image + title + timeAgo. `UpdateModel` already carries `likes`, `views`, and `createdAt` — they just aren't displayed on home cards.

No new packages needed. No data model changes. Pure UI layer change.

## Goals / Non-Goals

**Goals:**
- `ActionCard` renders background image in lower portion with gradient overlay, colored circular icon, title with colored underline accent bar, subtitle, and circular white arrow button.
- 2×2 grid layout retained (already in place via `IntrinsicHeight` rows).
- Home update cards show formatted date, view icon + count, heart icon + like count.
- Updates section header reads "Recent Updates".

**Non-Goals:**
- No changes to routing, controllers, or data layer.
- No new external packages.
- No changes to `ActionCard` usage outside home screen.
- No animation or interaction changes.

## Decisions

### 1. Background images — local assets vs network vs gradient fallback

**Decision:** Use local asset images per feature type, with a solid accent-tinted container as fallback if asset missing.

**Rationale:** Network images require a URL and add latency on home load. Local assets are instant and always available. The reference design uses static illustration-style images that don't change per MLA — local is the right fit.

**Alternative considered:** Gradient-only (no image) — simpler but doesn't match the reference visual fidelity.

### 2. Where to declare `backgroundImage` — asset path in `FeatureType` extension

**Decision:** Add `String get backgroundImage` to `FeatureTypeX` in `app_enums.dart` returning the asset path string per type.

**Rationale:** Keeps card data co-located with other per-feature metadata (color, icon, label). The widget stays generic — caller provides the path.

**Alternative:** Hardcode paths inside `ActionCard` — breaks separation of concerns.

### 3. `ActionCard` API change — add `backgroundImage` parameter

**Decision:** Add optional `String? backgroundImage` param to `ActionCard`. Existing callers (home screen) pass the asset path. Widget renders `Image.asset` inside a `Stack` beneath the content.

**Rationale:** Minimal API surface change. Optional keeps widget backward-compatible if used elsewhere without images.

### 4. Update card metadata display — inline row with icons

**Decision:** Add a `Row` below the title in `_activityCard` with: calendar icon + formatted date, eye icon + view count, heart icon + like count. Pass `UpdateModel` directly to the method instead of decomposed strings.

**Rationale:** `UpdateModel` already has all fields. Passing the full model is cleaner than adding 3 more positional params.

### 5. Card height for update feed

**Decision:** Increase feed `SizedBox` height from `200` to `240` to accommodate the new metadata row without clipping.

## Risks / Trade-offs

- **Asset availability**: If asset paths are not registered in `pubspec.yaml` or files don't exist, cards show fallback. → Add all 4 images to assets and register in pubspec before testing.
- **Card height variability**: `IntrinsicHeight` on action grid rows means tallest card drives row height. Background image area is fixed height so this is stable. → Fixed image height (e.g. 90px) in lower portion prevents unbounded growth.
- **`_activityCard` signature change**: Method now takes `UpdateModel` instead of `(String, String?, String, double)`. Only called from one place in `home_view.dart`. → Low risk, single call site.
