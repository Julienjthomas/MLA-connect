## ADDED Requirements

### Requirement: Home screen shows upcoming public events
The home screen SHALL display upcoming events from `GET /constituencies/public-events/upcoming`.

#### Scenario: Upcoming events exist
- **WHEN** the home screen loads and upcoming events exist
- **THEN** event cards are shown with event name, date/time, and location

#### Scenario: No upcoming events
- **WHEN** no upcoming events are scheduled
- **THEN** the events section is hidden or shows an empty state

### Requirement: Citizen can browse full public events feed
A public events feed screen SHALL display all events paginated from `GET /constituencies/:constituencyId/public-events`.

#### Scenario: Events feed loads
- **WHEN** the citizen navigates to the events screen
- **THEN** all events are listed with name, date, and venue; pull-to-refresh updates the list

### Requirement: Citizen can view a single public event
Tapping an event SHALL navigate to an event detail screen that fetches `GET /constituencies/:constituencyId/public-events/:publicEventId`.

#### Scenario: Event detail loads
- **WHEN** the citizen taps an event card
- **THEN** the full event details (name, description, date, time, venue, cover image) are displayed

### Requirement: Citizen can show interest in a public event
The event detail screen SHALL include a "Show Interest" button that calls `POST /constituencies/:constituencyId/public-events/:publicEventId/show-interest`.

#### Scenario: Show interest
- **WHEN** the citizen taps "Show Interest" on an event
- **THEN** the button changes to an "Interested" state and the interest count increments

#### Scenario: Already interested
- **WHEN** the citizen has already shown interest
- **THEN** the button shows "Interested" state on load; tapping it may withdraw interest (if API supports it)
