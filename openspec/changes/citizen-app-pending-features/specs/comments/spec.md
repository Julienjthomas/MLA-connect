## ADDED Requirements

### Requirement: Citizen can view comments on a concern, idea, or appreciation
The detail screen for concerns, ideas, and appreciations SHALL display comments fetched from the relevant `GET /constituencies/:id/<entity>/:entityId/comments` endpoint.

#### Scenario: Comments exist
- **WHEN** the citizen views a detail screen for a public concern/idea/appreciation
- **THEN** a comments section is shown with commenter name, avatar, comment text, and timestamp

#### Scenario: No comments
- **WHEN** there are no comments on the item
- **THEN** the comments section shows "No comments yet" and the compose field is visible

### Requirement: Citizen can post a comment
A text input at the bottom of the detail screen SHALL allow the citizen to type and submit a comment via `POST /constituencies/:id/<entity>/:entityId/comments`.

#### Scenario: Successful comment post
- **WHEN** the citizen types a comment and taps send
- **THEN** the comment appears in the list immediately and the input is cleared

#### Scenario: Empty comment submission
- **WHEN** the citizen taps send with an empty input
- **THEN** no API call is made and the input shows a validation message

### Requirement: Citizen can delete their own comment
Long-pressing own comment SHALL show a delete option that calls `DELETE /constituencies/:id/<entity>/:entityId/comments/:commentId`.

#### Scenario: Own comment long-pressed
- **WHEN** the citizen long-presses a comment they authored
- **THEN** a "Delete Comment" option appears in a bottom sheet or dialog

#### Scenario: Comment deleted
- **WHEN** the citizen confirms deletion
- **THEN** the comment is removed from the list and the comment count decrements

#### Scenario: Other citizen's comment long-pressed
- **WHEN** the citizen long-presses a comment authored by someone else
- **THEN** no delete option appears (only own comments can be deleted)

### Requirement: Comments load lazily (toggle visibility)
Comments SHALL be hidden by default on detail screens to avoid performance impact, revealed by tapping a "View comments (N)" button.

#### Scenario: Comments toggled open
- **WHEN** the citizen taps "View comments"
- **THEN** comments are fetched and rendered inline below the content
