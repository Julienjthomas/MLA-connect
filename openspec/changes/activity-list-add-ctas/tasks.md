## 1. Tab action mapping

- [x] 1.1 Add per-tab FAB label, icon, color, and route mapping on `ActivityTab` (or a small activity helper) for Reports, Ideas, Improvements, and Appreciations

## 2. Activity screen FAB

- [x] 2.1 Wrap `ActivityView` with tab-controller awareness and render one `FloatingActionButton.extended` on the scaffold for the active submission tab
- [x] 2.2 Hide the FAB on the Saved tab and wire `onPressed` to the mapped named route
- [x] 2.3 Add bottom list padding so the FAB does not cover the last activity row

## 3. Verification

- [ ] 3.1 Manual QA: switch across submission tabs and confirm FAB label and navigation target match each tab
- [ ] 3.2 Manual QA: confirm Saved tab shows no FAB and populated lists still scroll above the button
- [x] 3.3 Run `flutter analyze` on touched activity files
