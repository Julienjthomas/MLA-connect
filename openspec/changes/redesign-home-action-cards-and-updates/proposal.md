## Why

Action cards on the home screen use a plain white tile with no imagery, making them feel flat and generic. The updates feed shows title + time only — missing date, view count, and like count that users expect from content cards. Both sections need visual richness to match the reference design.

## What Changes

- **ActionCard widget**: Add background image support — each card gets a themed illustrative image in the lower half, accent-colored gradient overlay, and a circular arrow CTA button.
- **Home action grid**: Arrange 4 cards in a 2×2 grid (already the layout; refine card internals to match reference).
- **Updates section header**: Rename from generic "Updates" label to "Recent Updates".
- **Update feed cards**: Add date, view count (eye icon + number), and like count (heart icon + number) below each card title in the horizontal scroll list.
- **FeatureType extension**: Add `backgroundImage` asset path per feature type (report, idea, improve, appreciate).

## Capabilities

### New Capabilities
- `action-card-with-background`: ActionCard widget redesigned with background image, gradient overlay, and circular arrow button — matching the card style in the reference screenshot.
- `update-feed-card-metadata`: Update feed cards on home screen show formatted date, view count, and like count beneath the title.

### Modified Capabilities
- None

## Impact

- `lib/core/widgets/action_card.dart` — full widget rewrite
- `lib/features/home/views/home_view.dart` — `_activityCard` method updated, updates header title, grid unchanged structurally
- `lib/core/constants/app_enums.dart` — `FeatureType` extension gains `backgroundImage` getter
- `assets/images/` — needs 4 card background images (one per feature); use bundled assets or network fallback
- `pubspec.yaml` — ensure asset paths registered if new images added
