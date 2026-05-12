## ADDED Requirements

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
