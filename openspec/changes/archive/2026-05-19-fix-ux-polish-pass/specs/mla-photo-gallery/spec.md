## ADDED Requirements

### Requirement: MLA profile shows photo gallery section
The MLA profile screen SHALL include an optional photo gallery section that renders a horizontally scrollable strip of images sourced from the MLA record's `gallery_urls` field.

#### Scenario: Gallery has photos
- **WHEN** the MLA's `gallery_urls` field contains one or more URLs
- **THEN** the gallery section SHALL render a horizontally scrollable row of image thumbnails

#### Scenario: Gallery empty
- **WHEN** the MLA's `gallery_urls` field is empty or null
- **THEN** the gallery section SHALL not appear (no empty card)

### Requirement: Gallery thumbnail opens full image
Tapping a gallery thumbnail SHALL open a full-screen image viewer.

#### Scenario: User taps thumbnail
- **WHEN** the user taps a thumbnail in the gallery
- **THEN** a full-screen image viewer SHALL open showing that image with dismiss controls
