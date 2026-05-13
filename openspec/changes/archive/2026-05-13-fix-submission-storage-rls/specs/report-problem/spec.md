## MODIFIED Requirements

### Requirement: Submit creates report + media + initial timeline
On submit, the flow SHALL upload selected images to Supabase Storage bucket `submission-objects` under `problems/{auth_user_id}/…`, insert a row into `submissions` with `kind='report'`, insert media rows into `media_attachments` linked to that submission, and insert one `submission_status_history` row with status `submitted`. Submit SHALL succeed when all required fields are filled and Storage authorization succeeds.

#### Scenario: Successful submission
- **WHEN** the user taps Submit on the Review step with valid data and attachments
- **THEN** Storage uploads complete without RLS errors
- **THEN** database writes succeed, the flow advances to Success, and no error is shown

#### Scenario: Submit failure shows error
- **WHEN** the Supabase insert or Storage upload fails
- **THEN** an error snackbar is shown and the user remains on the Review step
