## ADDED Requirements

### Requirement: Submit creates submissions row
On submit, the suggest-improvement flow SHALL insert into `submissions` with `kind='suggestion'`, `reporter_id` set to the citizen reporter id used by other submission flows, `status='submitted'`, and a client-generated `reference_id` with prefix `SG`, then advance to Success.

#### Scenario: Successful submit
- **WHEN** the user confirms submit on the Review step with valid data
- **THEN** a row is inserted into `submissions` with `kind='suggestion'`
- **THEN** the flow advances to the Success step

#### Scenario: Submit uses reporter id
- **WHEN** the signed-in user submits an improvement
- **THEN** `reporter_id` on the inserted row equals `AuthController.submissionReporterId`
