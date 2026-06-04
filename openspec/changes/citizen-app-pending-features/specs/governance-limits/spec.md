## ADDED Requirements

### Requirement: Ward change is blocked during cool-off period
After a citizen's first ward change post-onboarding, the app SHALL block further ward changes for 1 year from the date of the last change, showing the number of days remaining.

#### Scenario: Ward change attempted within cool-off period
- **WHEN** the citizen attempts to change their ward within 1 year of the last change
- **THEN** the ward selection field is disabled and a message shows "Ward can be changed after X days"

#### Scenario: Ward change allowed after cool-off
- **WHEN** 1 year has elapsed since the last ward change
- **THEN** the ward selection is enabled normally

#### Scenario: First-time onboarding is exempt
- **WHEN** the citizen is completing onboarding for the first time (no prior ward set)
- **THEN** the cool-off check is skipped and ward selection proceeds normally

### Requirement: Daily concern submission is capped at 2 per rolling 24-hour window
The app SHALL prevent a citizen from submitting more than 2 concerns within a rolling 24-hour window.

#### Scenario: Limit not reached
- **WHEN** the citizen has submitted fewer than 2 concerns in the last 24 hours
- **THEN** the "Raise Issue" flow proceeds normally

#### Scenario: Limit reached
- **WHEN** the citizen has submitted 2 or more concerns in the last 24 hours
- **THEN** the app blocks the flow and shows a dialog: "You've reached the daily limit of 2 issues. You can submit again after [reset time]."

#### Scenario: Limit check uses activity summary
- **WHEN** the citizen initiates the concern submission flow
- **THEN** the app fetches `GET /citizens/activity/summary` to check the current count before allowing the flow to proceed
