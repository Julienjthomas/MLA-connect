## ADDED Requirements

### Requirement: Update feed card shows formatted date
Each update card in the home screen horizontal feed SHALL display the `createdAt` date formatted as "MMM d, yyyy" (e.g. "May 20, 2024") with a calendar icon, below the card title.

#### Scenario: Date renders on card
- **WHEN** an update card is rendered with a valid `createdAt`
- **THEN** a calendar icon and formatted date string appear below the title

### Requirement: Update feed card shows view count
Each update card SHALL display the `views` count from `UpdateModel` with an eye icon.

#### Scenario: View count renders
- **WHEN** `views` is 0 or greater
- **THEN** an eye icon and the integer view count appear in the metadata row

### Requirement: Update feed card shows like count
Each update card SHALL display the `likes` count from `UpdateModel` with a heart icon.

#### Scenario: Like count renders
- **WHEN** `likes` is 0 or greater
- **THEN** a heart icon and the integer like count appear in the metadata row

### Requirement: Updates section header title is "Recent Updates"
The section header above the updates horizontal feed on the home screen SHALL display the label "Recent Updates" instead of the previous generic "Updates" string.

#### Scenario: Header displays correct title
- **WHEN** the home screen renders the updates section
- **THEN** the section header title reads "Recent Updates"

### Requirement: Update feed card height accommodates metadata row
The horizontal feed container height SHALL be sufficient (≥ 240px) to display image, title, and the metadata row without clipping.

#### Scenario: Card content not clipped
- **WHEN** update card renders with image, title, and metadata row
- **THEN** all content is fully visible with no overflow clipping
