## ADDED Requirements

### Requirement: MLA profile fetched from mlas table
`MlaService.getMlaProfile` SHALL query the `mlas` table (not `mla_profile`) filtered by `is_current = true`.

#### Scenario: Fetch current MLA in live mode
- **WHEN** `getMlaProfile()` is called with `DemoConfig.enabled = false`
- **THEN** query runs on `mlas` with `.eq('is_current', true).limit(1).single()`
- **THEN** falls back to `MlaModel.placeholder` on error

### Requirement: MLA stats fetched from v_mla_stats view
`MlaService.getMlaProfile` SHALL additionally query `v_mla_stats` by `mla_id` and populate `MlaStats` from the view columns: `issues_resolved`, `active_projects`, `appreciations_count`, `ideas_implemented`.

#### Scenario: Fetch MLA with stats
- **WHEN** `getMlaProfile()` succeeds
- **THEN** `model.stats.issuesResolved` maps from `v_mla_stats.issues_resolved`
- **THEN** `model.stats.activeProjects` maps from `v_mla_stats.active_projects`
- **THEN** `model.stats.appreciations` maps from `v_mla_stats.appreciations_count`
- **THEN** `model.stats.ideasImplemented` maps from `v_mla_stats.ideas_implemented`

### Requirement: MlaModel maps flat mlas columns
`MlaModel.fromJson` SHALL read contact fields from flat columns on `mlas`: `office_phone` → `contact.phone`, `office_email` → `contact.email`, `office_address` → `contact.officeAddress`. It SHALL NOT expect nested `contact` or `stats` JSON objects in the row.

#### Scenario: Parse MLA from flat DB row
- **WHEN** a JSON row from `mlas` (flat columns) is passed to `MlaModel.fromJson`
- **THEN** `model.contact.phone` maps from `office_phone`
- **THEN** `model.contact.email` maps from `office_email`
- **THEN** `model.term` maps from `term_label`
- **THEN** `model.name` maps from `full_name`

### Requirement: MLA staff contact list fetched from mla_staff
`MlaService` SHALL expose a method `getPublicStaff()` that queries `mla_staff` filtered by `is_public = true` and `is_active = true`, ordered by `position`.

#### Scenario: Fetch staff contact list
- **WHEN** `getPublicStaff()` is called in live mode
- **THEN** query runs on `mla_staff` with `is_public=true` and `is_active=true`
- **THEN** results ordered by `position` ascending
