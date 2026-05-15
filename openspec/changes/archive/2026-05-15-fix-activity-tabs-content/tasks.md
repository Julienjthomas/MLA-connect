## 1. Update ActivityEmptyState widget

- [x] 1.1 Add required `ActivityTab tab` parameter to `ActivityEmptyState` constructor
- [x] 1.2 Add helper method or extension to derive empty state config (title, subtitle, primary button label, primary button route, accent color, icon) from `ActivityTab`
- [x] 1.3 Replace hardcoded "Report a Problem" primary button with tab-derived label and route
- [x] 1.4 Replace hardcoded secondary action cards row with the three cards for all tabs except the current one

## 2. Wire up call sites in activity_view.dart

- [x] 2.1 Pass `ActivityTab.reports` to `ActivityEmptyState` in `_ReportsTab`
- [x] 2.2 Pass `ActivityTab.ideas` to `ActivityEmptyState` in `_IdeasTab`
- [x] 2.3 Pass `ActivityTab.improvements` to `ActivityEmptyState` in `_ImprovementsTab`
- [x] 2.4 Pass `ActivityTab.appreciations` to `ActivityEmptyState` in `_AppreciationsTab`
