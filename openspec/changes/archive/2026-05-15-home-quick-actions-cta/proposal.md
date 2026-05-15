## Why

The home screen action CTAs still use the older vertical card layout (“What would you like to share today?”) with long labels and accent-colored titles. Product design now specifies a compact **Quick actions** block—horizontal tiles inside a single card—that matches the current home mock and reads faster at a glance.

## What Changes

- Replace the “What would you like…” section header with **Quick actions** inside a bordered surface card.
- Redesign the 2×2 action grid to **horizontal tiles**: colored icon chip on the left, short title + subtitle on the right.
- Shorten copy to match design: **Issue** / Report problem, **Idea** / Share thought, **Suggest** / Propose change, **Appreciate** / Recognize work (EN + ML l10n).
- Use neutral primary text for titles; keep feature accent colors on icons/backgrounds only.
- Preserve existing navigation targets (report, ideas, improvements, appreciation flows).
- Simplify or replace viewport-budget grid math if the compact layout keeps MLA Activity visible without oversized tiles.

## Capabilities

### New Capabilities

- `home-quick-actions`: Home-screen Quick actions card layout, labels, styling, and tap behavior for the four citizen engagement entry points.

### Modified Capabilities

- `responsive-action-grid`: Grid sizing rules may change because tiles are shorter (horizontal layout); MLA Activity visibility requirement must still hold.

## Impact

- `lib/features/home/views/home_view.dart` — section structure and grid wiring
- `lib/core/widgets/action_card.dart` — new horizontal variant or replacement widget
- `lib/core/constants/app_enums.dart` — optional short labels/subtitles for home CTAs
- `lib/l10n/app_en.arb`, `lib/l10n/app_ml.arb`, generated localizations
- `lib/core/constants/app_strings.dart` — new quick-actions strings
- No API, backend, or route changes
