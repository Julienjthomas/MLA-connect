## ADDED Requirements

### Requirement: Media upload uses presigned S3 URL flow
When a citizen attaches media (image/video) to a concern, idea, or appreciation, the app SHALL:
1. Request a presigned URL from the backend immediately before upload
2. PUT the file bytes directly to S3 using the presigned URL
3. Include the returned `s3_key` in the submission payload

The app SHALL NOT send raw file data to the backend API.

#### Scenario: Successful media upload before submission
- **WHEN** the user picks one or more media files and taps submit
- **THEN** the app requests a presigned URL per file, uploads each file to S3, and submits the form with the resulting `s3_key` values

#### Scenario: Presigned URL request fails
- **WHEN** the presigned URL endpoint returns an error
- **THEN** the submission is blocked and the user sees an error message asking them to retry

#### Scenario: S3 upload fails
- **WHEN** the PUT to S3 fails (network error or expired URL)
- **THEN** the submission is blocked and the user sees an error; the presigned URL is re-requested on retry

### Requirement: Presigned URL is requested immediately before upload
The app SHALL request the presigned URL at the moment of submission, not when the user picks the file, to avoid URL expiry.

#### Scenario: User picks file then waits before submitting
- **WHEN** the user picks a file, waits several minutes, then taps submit
- **THEN** the presigned URL is fetched fresh at submit time, not reused from when the file was picked

### Requirement: Multiple media files are uploaded sequentially
When a submission includes multiple media files, the app SHALL upload them one at a time and collect all `s3_key` values before submitting.

#### Scenario: Multiple files attached
- **WHEN** the user attaches 3 images
- **THEN** 3 presigned URLs are fetched and 3 uploads complete before the submission API call is made
