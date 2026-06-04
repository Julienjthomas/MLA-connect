## ADDED Requirements

### Requirement: Citizen can view notification center
A notification center screen SHALL display all notifications from `GET /citizens/notifications`, paginated, with the most recent first.

#### Scenario: Notifications exist
- **WHEN** the citizen opens the notification center
- **THEN** notifications are listed showing title, body, type icon, and relative timestamp

#### Scenario: No notifications
- **WHEN** the citizen has no notifications
- **THEN** an empty state is shown ("No notifications yet")

### Requirement: Unread notifications are visually distinguished
Unread notifications SHALL be visually distinct (e.g., bold text or colored background) from read notifications.

#### Scenario: Unread notification displayed
- **WHEN** a notification has `is_read: false`
- **THEN** it is visually highlighted in the list

### Requirement: Notifications are marked as read on open
When the citizen opens the notification center, all visible unread notifications SHALL be marked as read via `PUT /citizens/notifications/read` with their IDs.

#### Scenario: Opening notification center marks visible notifications as read
- **WHEN** the citizen opens the notification center and unread notifications are visible
- **THEN** a mark-as-read API call is made with the visible unread notification IDs

### Requirement: Tapping a notification deep-links to the relevant content
Tapping a notification SHALL navigate to the relevant screen based on `target_type` and `target_id`.

#### Scenario: Concern notification tapped
- **WHEN** the citizen taps a notification with `target_type: "concern"`
- **THEN** the app navigates to the concern detail screen for the referenced concern

#### Scenario: Unknown target type
- **WHEN** the notification has an unrecognized `target_type` or empty `action_url`
- **THEN** tapping it closes the notification center without navigating elsewhere

### Requirement: Notification badge on shell shows unread count
The bottom navigation bar icon for notifications SHALL display a badge with the count of unread notifications.

#### Scenario: Unread count > 0
- **WHEN** there are unread notifications
- **THEN** the notification icon shows a numeric badge

#### Scenario: All notifications read
- **WHEN** all notifications are read
- **THEN** the badge is hidden
