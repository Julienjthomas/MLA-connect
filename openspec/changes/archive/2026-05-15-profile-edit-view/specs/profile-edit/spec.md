## ADDED Requirements

### Requirement: User can open profile edit screen
The system SHALL navigate to a dedicated profile edit screen when the user taps the edit button on the profile view.

#### Scenario: Edit button tapped
- **WHEN** user taps the edit icon button in the profile user card
- **THEN** app navigates to `Routes.profileEdit` full-screen route

### Requirement: Edit screen pre-populates current profile data
The system SHALL pre-fill all form fields with the user's current profile values on screen load.

#### Scenario: Screen loads with existing data
- **WHEN** the profile edit screen opens
- **THEN** name field contains current user name, email field contains current email (or empty if not set), and avatar shows current avatar image

### Requirement: User can update name
The system SHALL allow the user to update their display name with validation.

#### Scenario: Valid name saved
- **WHEN** user enters a name of at least 2 characters and taps Save
- **THEN** system calls saveProfile with the new name and pops the screen on success

#### Scenario: Name too short
- **WHEN** user clears the name field or enters fewer than 2 characters and taps Save
- **THEN** form shows validation error and save is not submitted

### Requirement: User can update email
The system SHALL allow the user to optionally set or change their email address.

#### Scenario: Valid email saved
- **WHEN** user enters a valid email address and taps Save
- **THEN** system includes the email in the saveProfile call

#### Scenario: Empty email accepted
- **WHEN** user leaves the email field empty and taps Save
- **THEN** system saves profile without an email value (null/empty)

#### Scenario: Invalid email rejected
- **WHEN** user enters a malformed email string and taps Save
- **THEN** form shows email validation error and save is not submitted

### Requirement: User can update avatar
The system SHALL allow the user to pick and upload a new avatar from their photo library.

#### Scenario: Image picked and uploaded
- **WHEN** user taps the avatar area
- **THEN** system opens the image picker, uploads the selected image to storage, and shows a preview of the new avatar with an upload progress indicator

#### Scenario: Upload failure shown
- **WHEN** avatar upload fails
- **THEN** system shows a snackbar error and retains the previous avatar URL

### Requirement: Save persists changes
The system SHALL persist all edited profile fields on save.

#### Scenario: Successful save
- **WHEN** form is valid and user taps Save
- **THEN** system calls AuthController.saveProfile with name, email, and avatarUrl, then pops the edit screen

#### Scenario: Save failure shown
- **WHEN** saveProfile call fails
- **THEN** system shows a snackbar error and keeps the edit screen open for retry
