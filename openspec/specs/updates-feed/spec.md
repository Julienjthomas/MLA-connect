## Purpose

Define updates feed display, detail view, engagement (likes), and navigation behavior.

## Requirements

### Requirement: Update detail view
Tapping an update SHALL push `Routes.updateDetail` with the update id; the detail view SHALL show hero image (if present), category chip, title, time-ago, body, and engagement row (views, likes). The detail view SHALL show exactly one Share action — not two.

#### Scenario: Image-less update
- **WHEN** an update has `imageUrl == null`
- **THEN** the `SliverAppBar.expandedHeight` is 0 and no hero renders

#### Scenario: Single share action
- **WHEN** the update detail view renders
- **THEN** exactly one Share button or icon is visible

### Requirement: Like action on updates
Each update card and the update detail view SHALL show a like button. Tapping it SHALL toggle a like for the current user.

#### Scenario: Like an update
- **WHEN** the user taps the like button on an update
- **THEN** the like count increments by 1 and the icon changes to filled state

#### Scenario: Unlike an update
- **WHEN** the user taps the like button on an already-liked update
- **THEN** the like count decrements by 1 and the icon reverts to outline state

### Requirement: Update tiles show clickable images
Update list tiles SHALL render a thumbnail image when `imageUrl` is non-null. Tapping the image SHALL open the update detail view.

#### Scenario: Thumbnail visible
- **WHEN** an update has a non-null `imageUrl`
- **THEN** a thumbnail image renders in the tile

#### Scenario: Image tap navigates
- **WHEN** the user taps the image thumbnail
- **THEN** the update detail view opens

### Requirement: Long title handling
Update tile titles SHALL be clamped to 2 lines with `TextOverflow.ellipsis`.

#### Scenario: Long title
- **WHEN** an update title exceeds 2 lines of text
- **THEN** the title is truncated with "…" and the layout does not overflow

### Requirement: View All navigates to Updates Listing
The "View All" control in the Updates section on the Home page SHALL navigate to the full Updates tab or a dedicated updates listing page.

#### Scenario: Tap View All
- **WHEN** the user taps "View All" in the Home page Updates section
- **THEN** the Updates tab is activated or `Routes.updatesList` is pushed

### Requirement: Updates feed data loading
`UpdatesService.getUpdates()` SHALL query the `posts` table ordered by `published_at` descending, attach media, and sign URLs. On success it SHALL return the filtered list. On any error it SHALL rethrow so callers can handle it — it MUST NOT catch errors silently or return fabricated data.

#### Scenario: Successful load
- **WHEN** the posts table returns rows
- **THEN** `getUpdates()` returns the mapped `UpdateModel` list

#### Scenario: Database error propagates
- **WHEN** the Supabase query throws an exception
- **THEN** `getUpdates()` rethrows the exception to the caller
