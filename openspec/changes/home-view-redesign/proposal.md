## Why

The current home view lacks the rich, community-focused layout shown in the target design. Key elements are missing: an expanded MLA profile card with contact CTAs, a community hero banner with live issue stats, a redesigned quick actions grid with subtitles, a community impact summary row, and a prominent "Raise New Issue" FAB. The app header also needs a profile avatar and the tagline "Your voice. Our priority."

## What Changes

- **App header**: Add user profile avatar; replace rocket icon with app name + tagline ("Your voice. Our priority.")
- **MLA Hero Card**: Expand from compact 80dp banner → full card with photo, name, constituency, and three contact action buttons (Contact Office, Message MLA, Meet MLA)
- **Community Hero Banner**: New full-width purple gradient banner with headline, subtext, and a stats row (Active Issues, In Progress, Resolved) pulled from MLA stats
- **Quick Actions Section**: Redesign 2×2 grid tiles to card style (icon centered above title + subtitle + arrow) matching the snapshot; update labels (Report Issue, Share Idea, Request Help, Appreciate Work)
- **Section header**: Rename "What would you like to do?" for quick actions section
- **Recent Updates**: Add status badge chips (In Progress / Resolved / New) overlaid on update card thumbnails
- **Community Impact**: New section with tagline and three stat chips (Issues Resolved, Ideas Implemented, Appreciations Shared) sourced from MlaStats
- **Raise New Issue FAB**: Persistent bottom button above nav bar

## Capabilities

### New Capabilities
- `home-mla-hero-card`: Full MLA profile card with photo, name, constituency label, and contact action buttons
- `home-community-banner`: Purple gradient hero banner with headline, subtext, and live issue stats row
- `home-quick-actions-redesign`: Redesigned quick actions with centered icon, title, subtitle, arrow; section header "What would you like to do?"
- `home-update-card-status-badge`: Status badge overlay on recent update cards (In Progress / Resolved / New)
- `home-community-impact`: Community impact stats row (issues resolved, ideas implemented, appreciations)
- `home-raise-issue-fab`: Sticky "Raise New Issue" button pinned above bottom nav

### Modified Capabilities
- `responsive-action-grid`: Quick action tile layout changes from horizontal row to vertical card style

## Impact

- `lib/features/home/views/home_view.dart` — major restructure
- `lib/features/home/widgets/mla_hero_banner.dart` — replaced with full card
- `lib/features/home/widgets/quick_action_tile.dart` — tile layout change
- `lib/features/home/widgets/quick_actions_section.dart` — section header text change
- `lib/core/constants/app_strings.dart` — new strings for tagline, banner headline, section labels, FAB label, impact labels
- `lib/l10n/` — new localization keys
- `lib/data/models/mla_model.dart` — verify stats fields cover activeIssues / inProgress counts (may need additions)
