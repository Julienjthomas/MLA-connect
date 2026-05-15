## Context

`ActivityView` uses a five-tab `TabBar` (Reports, Ideas, Improvements, Appreciations, Saved). Empty tabs already render `EmptyState` with `PrimaryButton` actions to `Routes.reportFlow`, `Routes.ideasFlow`, `Routes.improvementsFlow`, and `Routes.appreciationFlow`. Populated tabs render scrollable lists only. `AchievementsListingView` already uses `FloatingActionButton.extended` as the add pattern in the app.

## Goals / Non-Goals

**Goals:**

- Show one extended FAB on My Activity for the active submission tab.
- Swap FAB label, icon accent, and navigation target when the user changes tabs.
- Reuse existing named routes; no new submission APIs.

**Non-Goals:**

- Saved-tab bookmark creation.
- Replacing empty-state CTAs.
- Home-screen quick actions or summary-card taps.

## Decisions

1. **Single scaffold FAB driven by tab index** — `ActivityView` listens to `DefaultTabController` and updates one `floatingActionButton` instead of embedding a FAB in each tab page. That avoids duplicate FABs inside `TabBarView` children and matches Material guidance for one primary action per screen.

2. **`FloatingActionButton.extended`** — Match `AchievementsListingView`: icon plus short label (e.g. "Report a Problem"). Use `FeatureType` / `ActivityTab` colors for background where practical.

3. **Hide FAB on Saved** — Saved is read-only for bookmarks; no add action.

4. **Keep empty-state buttons** — Empty and non-empty tabs share the same destination; empty tabs keep centered `PrimaryButton` for first-time users.

**Alternatives considered:** Inline list-header buttons (rejected; user confirmed FAB). Per-tab nested `Scaffold` FABs (rejected; harder to sync with `TabBar`).

## Risks / Trade-offs

- **[Risk] FAB overlaps last list row** — Mitigation: add bottom padding on list `ListView`s equal to FAB safe area.
- **[Risk] Tab controller not available in `GetView`** — Mitigation: use `DefaultTabController.of(context)` in a small listener widget or pass `TabController` from a `StatefulWidget` wrapper.

## Migration Plan

Ship as a UI-only Flutter change. No backend or migration work.

## Open Questions

- Whether FAB labels should come from `AppStrings` / l10n in the same pass or stay English literals aligned with empty states.
