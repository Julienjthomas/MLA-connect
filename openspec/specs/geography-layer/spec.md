## Purpose

Define geography data access for assembly constituencies, local bodies, and wards used in onboarding and profile flows.
## Requirements
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

### Requirement: Assembly constituencies are queryable
The data layer SHALL expose assembly constituencies from the `assembly_constituencies` table (or equivalent) with stable `id`, `name`, and `slug` fields.

#### Scenario: Fetch all constituencies
- **WHEN** the client requests assembly constituencies in live mode
- **THEN** the query returns at least the rows for Balussery, Koduvalli, and Perambra ordered by `name`

### Requirement: Local bodies belong to an assembly constituency
Each `local_bodies` row used in onboarding SHALL reference `assembly_constituency_id` so the client can filter panchayaths after AC selection.

#### Scenario: Filter local bodies by AC
- **WHEN** `getLocalBodies(assemblyConstituencyId)` is called in live mode
- **THEN** the query returns only local bodies whose `assembly_constituency_id` matches the argument

### Requirement: Stakeholder panchayath coverage for Balussery
For the Balussery assembly constituency, seeded or linked local bodies SHALL include: Atholi, Balussery, Kayanna, Koorachundu, Kottur, Naduvannur, Panangad, Ulliyeri, Unnikulam.

#### Scenario: Balussery picker coverage
- **WHEN** the user selects Balussery assembly constituency during onboarding
- **THEN** the local body picker includes all names in the stakeholder list (allowing spelling normalization only if documented in tasks)

### Requirement: Stakeholder panchayath coverage for Koduvalli
For the Koduvalli assembly constituency, seeded or linked local bodies SHALL include: Kodenchery, Kizhakkoth, Madavoor, Narikkuni, Omassery, Puduppadi, Thamarassery, Kattippara, Kodanchery, Koduvalli.

#### Scenario: Koduvalli picker coverage
- **WHEN** the user selects Koduvalli assembly constituency during onboarding
- **THEN** the local body picker includes all names in the stakeholder list

### Requirement: Stakeholder panchayath coverage for Perambra
For the Perambra assembly constituency, seeded or linked local bodies SHALL include: Arikkulam, Chakkittapara, Changaroth, Cheruvannur, Keezhariyur, Koothali, Meppayur, Nochad, Perambra, Thurayur.

#### Scenario: Perambra picker coverage
- **WHEN** the user selects Perambra assembly constituency during onboarding
- **THEN** the local body picker includes all names in the stakeholder list

### Requirement: Ward planning totals documented
Project documentation or migration notes SHALL record Balussery ward-count targets (Atholi 18, Balussery 18, Kayanna 13, Koorachundu 15, Kottur 15, Naduvannur 16, Panangad 14, Ulliyeri 21, Unnikulam 16; total estimated 146) for QA parity even if not all ward rows exist on first ship.

#### Scenario: QA reference present
- **WHEN** engineers validate ward pickers for Balussery
- **THEN** they can compare counts against the documented targets

