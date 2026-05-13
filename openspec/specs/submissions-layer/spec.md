## Purpose

Define submission read/write behavior against the unified `submissions` table and related media rows.

## Requirements

### Requirement: Reports read from submissions table
`ReportService` SHALL query the `submissions` table with `kind = 'report'` and `reporter_id = userId` when fetching a user's reports.

#### Scenario: Fetch my reports
- **WHEN** `getMyReports(userId)` is called in live mode
- **THEN** query runs on `submissions` filtered by `kind='report'` and `reporter_id=userId`
- **THEN** results are ordered by `created_at` descending

#### Scenario: Fetch single report
- **WHEN** `getReport(id)` is called in live mode
- **THEN** query runs on `submissions` with `.eq('id', id)` and returns null if not found

### Requirement: Report submission inserts to submissions table
`ReportService.submitReport` SHALL insert a row to `submissions` with `kind='report'`, `reporter_id=userId`, and a generated `reference_id` with prefix `RP`.

#### Scenario: Submit report with media
- **WHEN** `submitReport(data, userId)` is called with non-empty `mediaUrls`
- **THEN** a row is inserted into `submissions` with `kind='report'`
- **THEN** media rows are inserted into `media_attachments` with `attachable_type='submission'` and `attachable_id=submissionId`
- **THEN** an initial status history row is inserted into `submission_status_history` with `to_status='submitted'`

#### Scenario: Submit report without media
- **WHEN** `submitReport(data, userId)` is called with empty `mediaUrls`
- **THEN** no rows are inserted into `media_attachments`

### Requirement: Report model maps submissions columns
`ReportModel.fromJson` SHALL map DB column `reporter_id` to `userId`, and read media from the `media_attachments` relation (not `report_media`), and timeline from `submission_status_history` (not `report_timeline`).

#### Scenario: Parse report from DB response
- **WHEN** a JSON row from `submissions` with nested `media_attachments` and `submission_status_history` is passed to `ReportModel.fromJson`
- **THEN** `model.userId` equals the value of `reporter_id` in the JSON
- **THEN** `model.mediaUrls` is populated from `media_attachments` items
- **THEN** `model.timeline` is populated from `submission_status_history` items

### Requirement: Appreciations read from submissions table
`AppreciationService` SHALL query `submissions` with `kind = 'appreciation'` and `reporter_id = userId`.

#### Scenario: Fetch my appreciations
- **WHEN** `getMyAppreciations(userId)` is called in live mode
- **THEN** query runs on `submissions` filtered by `kind='appreciation'` and `reporter_id=userId`

### Requirement: Appreciation submission inserts to submissions table
`AppreciationService.submit` SHALL insert to `submissions` with `kind='appreciation'`, `reporter_id=userId`, `reference_id` with prefix `AP`, and map form fields to the correct `submissions` columns (`target_type`, `recipient_staff_name`, `recipient_department`, `related_project_name`, `description` for message).

#### Scenario: Submit appreciation with media
- **WHEN** `submit(data, userId)` is called with non-empty `mediaUrls`
- **THEN** row inserted to `submissions` with `kind='appreciation'`
- **THEN** media rows inserted to `media_attachments` with `attachable_type='submission'`

### Requirement: Ideas read from submissions table
`IdeaService` SHALL query `submissions` with `kind = 'idea'` and `reporter_id = userId`.

#### Scenario: Fetch my ideas
- **WHEN** `getMyIdeas(userId)` is called in live mode
- **THEN** query runs on `submissions` filtered by `kind='idea'` and `reporter_id=userId`

### Requirement: Idea submission inserts to submissions table
`IdeaService.submit` SHALL insert to `submissions` with `kind='idea'`, `reporter_id=userId`, `reference_id` with prefix `ID`, and map `allowDiscussion` → `allow_community_discussion`, `allowContact` → `allow_mla_office_contact`, `estimatedResources` is dropped (no matching column; cost fields use `estimated_cost_min`/`estimated_cost_max` if available).

#### Scenario: Submit idea
- **WHEN** `submit(data, userId)` is called in live mode
- **THEN** row inserted to `submissions` with `kind='idea'` and correct column mapping

### Requirement: reference_id generated client-side
All submission inserts SHALL include a `reference_id` generated as `<PREFIX><YYYYMMDD><6-char-random-hex>` where prefix is `RP` for reports, `AP` for appreciations, `ID` for ideas.

#### Scenario: Generate reference_id for report
- **WHEN** a report is submitted
- **THEN** `reference_id` starts with `RP` and is unique per insert attempt

### Requirement: Submission media uploaded before database insert
Submission services SHALL accept `mediaUrls` produced only after successful Storage uploads to `submission-objects` under the kind folder matching the submission type (`problems` for reports, `ideas` for ideas, `improvements` for improvements, `appreciations` for appreciations) and the reporter's auth user id as the second path segment.

#### Scenario: Report with attachments
- **WHEN** `ReportService.submitReport` is called with non-empty `mediaUrls` after the report flow uploaded images
- **THEN** each URL points to an object under `submission-objects/problems/{auth_user_id}/…`
- **THEN** `media_attachments` rows reference those URLs and a storage path consistent with the upload

#### Scenario: Upload failure blocks submit
- **WHEN** Storage upload fails with an authorization error during a submission flow
- **THEN** no `submissions` row is inserted for that submit attempt
- **THEN** the user sees an error and remains on the review step
