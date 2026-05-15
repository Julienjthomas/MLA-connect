## ADDED Requirements

### Requirement: Avatar selection during profile setup
The profile setup screen SHALL allow users to pick a photo from their gallery and upload it as their avatar.

#### Scenario: User taps camera button
- **WHEN** the user taps the camera icon on the profile setup screen
- **THEN** the device gallery opens for image selection

#### Scenario: Image preview shown after pick
- **WHEN** the user selects an image from the gallery
- **THEN** the selected image is displayed in the avatar circle immediately

#### Scenario: Upload succeeds
- **WHEN** the image is picked successfully
- **THEN** the image is uploaded to Supabase storage and the returned URL is stored for profile save

#### Scenario: Upload fails
- **WHEN** the upload to Supabase storage fails
- **THEN** a snackbar error is shown and the avatar field remains empty (profile can still be saved without it)

#### Scenario: Profile saved with avatar
- **WHEN** the user submits the profile setup form and an avatar URL was captured
- **THEN** the avatar URL is included in the profile save call
