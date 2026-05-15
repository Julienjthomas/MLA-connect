## ADDED Requirements

### Requirement: Improvements read from submissions table
`ImprovementService` SHALL query the `submissions` table with `kind = 'suggestion'` and `reporter_id = userId` when fetching a user's improvement suggestions.

#### Scenario: Fetch my improvements
- **WHEN** `getMyImprovements(userId)` is called in live mode
- **THEN** query runs on `submissions` filtered by `kind='suggestion'` and `reporter_id=userId`
- **THEN** results are ordered by `created_at` descending
- **THEN** `SubmissionMediaMerger.attachForSubmissions` runs before model parsing

### Requirement: Improvement submission inserts to submissions table
`ImprovementService.submit` SHALL insert a row to `submissions` with `kind='suggestion'`, `reporter_id=userId`, a generated `reference_id` with prefix `SG`, and map suggestion form fields to `submissions` columns (`description` for suggestion text, department and location fields to the appropriate nullable columns).

#### Scenario: Submit improvement
- **WHEN** `submit(data, userId)` is called in live mode
- **THEN** a row is inserted into `submissions` with `kind='suggestion'`
- **THEN** `status` is `submitted`

#### Scenario: Submit improvement with media
- **WHEN** `submit(data, userId)` is called with non-empty `mediaUrls`
- **THEN** media rows are inserted into `media_attachments` with `attachable_type='submission'` and `attachable_id=submissionId`

### Requirement: Improvement model maps submissions columns
`ImprovementModel.fromJson` SHALL map DB column `reporter_id` to `userId`, read suggestion text from `description`, and read media from merged `media_attachments` data using the same helper contract as other submission models.

#### Scenario: Parse improvement from DB response
- **WHEN** a JSON row from `submissions` with merged `media_attachments` is passed to `ImprovementModel.fromJson`
- **THEN** `model.userId` equals the value of `reporter_id` in the JSON
- **THEN** `model.suggestion` equals the value of `description` in the JSON

## MODIFIED Requirements

### Requirement: Appreciations read from submissions table
`AppreciationService` SHALL query `submissions` with `kind = 'appreciation'` and `reporter_id = userId`.

#### Scenario: Fetch my appreciations
- **WHEN** `getMyAppreciations(userId)` is called in live mode
- **THEN** query runs on `submissions` filtered by `kind='appreciation'` and `reporter_id=userId`
- **THEN** results are ordered by `created_at` descending
- **THEN** `SubmissionMediaMerger.attachForSubmissions` runs before model parsing

### Requirement: Ideas read from submissions table
`IdeaService` SHALL query `submissions` with `kind = 'idea'` and `reporter_id = userId`.

#### Scenario: Fetch my ideas
- **WHEN** `getMyIdeas(userId)` is called in live mode
- **THEN** query runs on `submissions` filtered by `kind='idea'` and `reporter_id=userId`
- **THEN** results are ordered by `created_at` descending
- **THEN** `SubmissionMediaMerger.attachForSubmissions` runs before model parsing

### Requirement: reference_id generated client-side
All submission inserts SHALL include a `reference_id` generated as `<PREFIX><YYYYMMDD><6-char-random-hex>` where prefix is `RP` for reports, `AP` for appreciations, `ID` for ideas, and `SG` for improvement suggestions.

#### Scenario: Generate reference_id for report
- **WHEN** a report is submitted
- **THEN** `reference_id` starts with `RP` and is unique per insert attempt

#### Scenario: Generate reference_id for improvement
- **WHEN** an improvement suggestion is submitted
- **THEN** `reference_id` starts with `SG` and is unique per insert attempt
