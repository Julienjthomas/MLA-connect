## ADDED Requirements

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
