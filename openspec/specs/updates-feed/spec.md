## ADDED Requirements

### Requirement: Category filter chips
The Updates tab SHALL render horizontal filter chips for every value in `UpdateCategory` (`all`, `development`, `events`, `resolved`, `announcements`).

#### Scenario: Filter selection
- **WHEN** the user taps a chip
- **THEN** the feed shows only updates whose category matches; `all` shows everything

### Requirement: Update list with shimmer + empty + refresh
The feed SHALL show shimmer skeletons while loading, an `EmptyState` when filtered list is empty, and support pull-to-refresh.

#### Scenario: Pull to refresh
- **WHEN** the user pulls down on the list
- **THEN** `loadUpdates()` re-fetches from Supabase

### Requirement: Mock fallback when service fails or returns empty
When the updates service returns an empty list or throws, the controller SHALL populate `updates` with `_mockUpdates` so the screen is never blank in demos.

#### Scenario: Service error
- **WHEN** Supabase fetch throws
- **THEN** five mock Kerala-themed updates render

### Requirement: Update detail view
Tapping an update SHALL push `Routes.updateDetail` with the update id; the detail view SHALL show hero image (if present), category chip, title, time-ago, body, and engagement row (views, likes, share).

#### Scenario: Image-less update
- **WHEN** an update has `imageUrl == null`
- **THEN** the `SliverAppBar.expandedHeight` is 0 and no hero renders
