## ADDED Requirements

### Requirement: Updates feed shows empty state when no posts exist
When `UpdatesController.filteredUpdates` is empty and no error is present, the updates view SHALL render an `EmptyState` widget with title "No updates" and message "No updates for this category yet."

#### Scenario: Empty database
- **WHEN** the posts table returns zero rows
- **THEN** the updates list is empty and the EmptyState widget is visible

#### Scenario: Category filter with no matches
- **WHEN** a category is selected that has no matching posts
- **THEN** the EmptyState widget is visible instead of a blank list

### Requirement: Updates feed shows error state on fetch failure
When `UpdatesController` catches an exception from `UpdatesService.getUpdates()`, it SHALL set a non-empty `error` observable. The updates view SHALL render an error message and a retry button when `error` is non-empty.

#### Scenario: Network failure
- **WHEN** Supabase is unreachable and `getUpdates()` throws
- **THEN** `controller.error` is non-empty and an error message with a retry button is shown

#### Scenario: Retry clears error on success
- **WHEN** the user taps retry and the next `getUpdates()` call succeeds
- **THEN** `controller.error` is cleared and the updates list renders

#### Scenario: Retry shows error again on continued failure
- **WHEN** the user taps retry and `getUpdates()` throws again
- **THEN** `controller.error` remains non-empty and the error state remains visible
