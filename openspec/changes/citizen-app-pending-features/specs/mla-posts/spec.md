## ADDED Requirements

### Requirement: Home screen shows recent MLA posts
The home screen SHALL display the most recent MLA posts fetched from `GET /constituencies/posts/recent`.

#### Scenario: Posts available
- **WHEN** the home screen loads and posts exist
- **THEN** a horizontal or vertical list of recent post cards is displayed with title, cover image, and date

#### Scenario: No posts available
- **WHEN** no posts have been published
- **THEN** the posts section is hidden or shows an empty state

### Requirement: Citizen can browse full MLA posts feed
A dedicated posts feed screen SHALL display all MLA posts paginated from `GET /constituencies/:constituencyId/posts`.

#### Scenario: Feed loads
- **WHEN** the citizen navigates to the posts feed
- **THEN** posts are listed with cover image, title, and published date; pagination loads more on scroll

### Requirement: Citizen can view a single MLA post
Tapping a post SHALL navigate to a post detail screen that fetches `GET /constituencies/:constituencyId/posts/:postId`.

#### Scenario: Post detail loads
- **WHEN** the citizen taps a post card
- **THEN** the full post content (title, body, media, date) is displayed

### Requirement: Citizen can like an MLA post
The post detail screen SHALL include a like button that calls `POST /constituencies/:constituencyId/posts/:postId/like`.

#### Scenario: Like a post
- **WHEN** the citizen taps the like button on a post they have not yet liked
- **THEN** the like count increments and the button shows the liked state

#### Scenario: Unlike a post
- **WHEN** the citizen taps the like button on a post they already liked
- **THEN** the like is removed and the count decrements
