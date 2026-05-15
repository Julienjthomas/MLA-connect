## MODIFIED Requirements

### Requirement: Edit button navigates to profile edit screen
The edit icon button in `_UserCard` SHALL navigate to the profile edit route instead of being a no-op.

#### Scenario: Edit button tapped
- **WHEN** user taps the edit icon in the profile user card
- **THEN** app calls `Get.toNamed(Routes.profileEdit)` to navigate to the profile edit screen
