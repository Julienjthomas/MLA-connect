## Purpose

Define the suggest-improvement submission flow and inputs.
## Requirements
### Requirement: Required improvement inputs
The Suggestion step SHALL require: suggestion text and department. The Location step SHALL require: location text. No GPS icon SHALL appear in any location field in this flow.

#### Scenario: Missing suggestion text
- **WHEN** suggestion is empty
- **THEN** advance is blocked

#### Scenario: No GPS icon
- **WHEN** any location field renders in the improvement flow
- **THEN** no GPS icon appears as a field prefix or suffix

### Requirement: Submit creates submissions row
On submit, the suggest-improvement flow SHALL insert into `submissions` with `kind='suggestion'`, `reporter_id` set to the citizen reporter id used by other submission flows, `status='submitted'`, and a client-generated `reference_id` with prefix `SG`, then advance to Success.

#### Scenario: Successful submit
- **WHEN** the user confirms submit on the Review step with valid data
- **THEN** a row is inserted into `submissions` with `kind='suggestion'`
- **THEN** the flow advances to the Success step

#### Scenario: Submit uses reporter id
- **WHEN** the signed-in user submits an improvement
- **THEN** `reporter_id` on the inserted row equals `AuthController.submissionReporterId`

