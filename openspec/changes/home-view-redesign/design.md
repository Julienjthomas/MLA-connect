## Context

The home view currently uses a compact MLA banner (80dp), a flat quick-actions grid, and minimal community context. The target design is a richer, community-first layout with a full MLA profile card, a hero stats banner, redesigned action cards, update cards with status badges, a community impact row, and a sticky FAB.

The app already has `MlaStats` on `MlaModel` (issuesResolved, activeProjects, appreciations, ideasImplemented) but lacks `activeIssues` and `inProgressCount` fields needed for the banner stats row. Contact actions (phone/email) are already in `MlaContact`.

## Goals / Non-Goals

**Goals:**
- Match the target snapshot layout and visual style
- Reuse existing data (MlaModel, MlaStats, MlaContact, UpdateModel)
- Keep all navigation routes unchanged
- Stay within the existing GetX + theme system

**Non-Goals:**
- Live real-time stat subscriptions (use existing loaded data)
- Backend changes to add new stat fields (use proxy from existing fields)
- Localization of new strings beyond adding arb keys

## Decisions

**D1 — MLA Hero Card replaces MlaHeroBanner widget**
Replace `MlaHeroBanner` with a new `MlaHeroCard` widget. The old compact 80dp banner is retired. `MlaHeroCard` renders the full card with photo (left), name + constituency (right), and three tappable action buttons below.
- Contact Office → `launch(tel:phone)`
- Message MLA → navigate to MLA office chat route
- Meet MLA → navigate to `Routes.mlaDetail`

**D2 — Stats row uses existing MlaStats fields as proxies**
The banner needs "Active Issues", "In Progress", "Resolved". MlaStats has `issuesResolved` and `activeProjects`. We map:
- Active Issues → `activeProjects` (best available proxy)
- In Progress → hardcoded 0 or omitted until a real field exists  
- Resolved → `issuesResolved`

Alternative considered: add new DB columns — deferred, out of scope.

**D3 — Community Hero Banner is a standalone widget**
New `CommunityHeroBanner` widget: purple gradient container, headline + subtext, stats row. Accepts `MlaStats`. Lives in `lib/features/home/widgets/`.

**D4 — Quick action tiles go vertical card style**
`QuickActionTile` gains a `vertical` layout mode: icon centered at top, bold title, subtitle text, small arrow at bottom. Section header text changes to "What would you like to do?". The tile row height increases to ~130dp to accommodate the vertical layout.

Alternative considered: new tile widget — updating existing widget with a layout flag keeps the change minimal.

**D5 — Status badge on update cards**
`UpdateModel` already has a `status` field (check model). A colored chip is overlaid on the thumbnail using a `Stack`. Colors: In Progress = orange, Resolved = green, New = blue.

**D6 — Community Impact row as inline widget in HomeView**
A simple `Row` of three stat chips built inline in `home_view.dart`. No separate widget file needed given simplicity.

**D7 — Raise New Issue FAB**
Use `Scaffold.bottomNavigationBar` slot is owned by the shell. Instead, place a full-width `ElevatedButton` as the last sliver item in the `CustomScrollView`, with enough bottom padding to clear the shell nav bar. This avoids shell refactoring.

**D8 — AppBar update**
Replace rocket icon with app name text + tagline "Your voice. Our priority." as subtitle. Add user profile avatar (circle) on the right, using the existing `AuthController.user` photo URL.

## Risks / Trade-offs

- **Stat field mismatch**: `activeProjects` ≠ active issues count. → Accept proxy for now, label carefully.
- **UpdateModel status field**: If `UpdateModel` doesn't have a status string, badge will be skipped. → Check and add fallback "New" default.
- **FAB placement**: Bottom sliver button scrolls with content rather than floating. → Acceptable per scope; a true FAB would need shell changes.
- **MlaContact phone**: `url_launcher` may already be a dep; confirm before adding.
