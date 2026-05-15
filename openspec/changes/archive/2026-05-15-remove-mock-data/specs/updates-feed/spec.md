## REMOVED Requirements

### Requirement: Mock fallback data
**Reason**: Hardcoded mock posts mask real failures and ship fake content to users. Real empty/error states now handle both cases correctly.
**Migration**: Delete `_mockUpdates` static field and the fallback branch in `getUpdates()`. The method SHALL throw on error so callers can distinguish failure from empty.

## MODIFIED Requirements

### Requirement: Updates feed data loading
`UpdatesService.getUpdates()` SHALL query the `posts` table ordered by `published_at` descending, attach media, and sign URLs. On success it SHALL return the filtered list. On any error it SHALL rethrow so callers can handle it — it MUST NOT catch errors silently or return fabricated data.

#### Scenario: Successful load
- **WHEN** the posts table returns rows
- **THEN** `getUpdates()` returns the mapped `UpdateModel` list

#### Scenario: Database error propagates
- **WHEN** the Supabase query throws an exception
- **THEN** `getUpdates()` rethrows the exception to the caller
