## ADDED Requirements

### Requirement: Local bodies fetched from local_bodies table
`UserService.getLocalBodies` SHALL query the `local_bodies` table (replacing the old `panchayats` table query) and return a list of `LocalBodyModel`.

#### Scenario: Fetch local bodies in live mode
- **WHEN** `getLocalBodies()` is called with `DemoConfig.enabled = false`
- **THEN** query runs on `local_bodies` ordered by `name`
- **THEN** returns list of `LocalBodyModel` with `id`, `name`, `type` fields

### Requirement: Wards fetched using local_body_id
`UserService.getWards` SHALL query the `wards` table filtering by `local_body_id` (not `panchayat_id`), and map `ward_number` (not `number`) to `WardModel.wardNumber`.

#### Scenario: Fetch wards for a local body
- **WHEN** `getWards(localBodyId)` is called in live mode
- **THEN** query runs on `wards` with `.eq('local_body_id', localBodyId)`
- **THEN** results ordered by `ward_number`
- **THEN** each `WardModel.wardNumber` maps from `ward_number` column

### Requirement: LocalBodyModel replaces PanchayatModel
`PanchayatModel` SHALL be removed. `LocalBodyModel` with fields `id`, `name`, `type` SHALL replace it throughout models, services, and controllers.

#### Scenario: Parse local body from DB
- **WHEN** a JSON row from `local_bodies` is passed to `LocalBodyModel.fromJson`
- **THEN** `model.id`, `model.name`, `model.type` are correctly populated

### Requirement: WardModel uses correct field names
`WardModel` SHALL use `localBodyId` (mapped from `local_body_id`) and `wardNumber` (mapped from `ward_number`). `displayName` getter SHALL use `wardNumber`.

#### Scenario: WardModel display name
- **WHEN** a `WardModel` with `wardNumber=12` and `name='Kuttikattoor'` is created
- **THEN** `displayName` returns `'Ward 12 – Kuttikattoor'`

### Requirement: OnboardingController fallback uses LocalBodyModel
The `_fallbackPanchayats` list in `OnboardingController` SHALL be replaced with `_fallbackLocalBodies` of type `List<LocalBodyModel>`. All controller methods referencing panchayat SHALL reference localBody.

#### Scenario: Demo mode loads fallback local bodies
- **WHEN** `loadPanchayats()` (renamed to `loadLocalBodies()`) is called with `DemoConfig.enabled = true`
- **THEN** `localBodies` list is populated with fallback `LocalBodyModel` items
