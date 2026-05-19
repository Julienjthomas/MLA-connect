## ADDED Requirements

### Requirement: ActionCard renders background image with gradient overlay
The ActionCard widget SHALL accept an optional `backgroundImage` asset path and render it in the lower portion of the card inside a `Stack`. A vertical gradient overlay SHALL fade from transparent at top to the card's light accent color at bottom, ensuring text above remains readable.

#### Scenario: Card with background image provided
- **WHEN** `backgroundImage` is a valid asset path
- **THEN** the image renders in the bottom ~40% of the card, clipped to the card's border radius, with a gradient overlay on top

#### Scenario: Card with no background image
- **WHEN** `backgroundImage` is null
- **THEN** the card renders icon, title, and subtitle without an image area, maintaining existing layout

### Requirement: ActionCard displays circular icon container at top
The ActionCard SHALL render a circular (or rounded square) icon container at the top-left using the accent color with low opacity background, matching the reference design.

#### Scenario: Icon container renders
- **WHEN** ActionCard is built
- **THEN** icon is displayed in a container with accent color at 15% opacity, border radius ≥ 50% of container size

### Requirement: ActionCard displays accent underline below title
The ActionCard SHALL render a short horizontal bar (underline accent) below the title text, colored with the card's accent color, to match the reference card style.

#### Scenario: Underline renders below title
- **WHEN** ActionCard is built with a title
- **THEN** a 24px wide, 3px tall colored bar appears directly below the title text

### Requirement: ActionCard displays circular arrow CTA button
The ActionCard SHALL render a white circular button with a right-pointing arrow icon (→) in the bottom-right area of the card, overlaid on the background image zone.

#### Scenario: Arrow button renders
- **WHEN** ActionCard is built
- **THEN** a white filled circle with an arrow icon is visible at the bottom-right of the card

#### Scenario: Arrow button tap triggers onTap
- **WHEN** user taps the circular arrow button
- **THEN** the card's `onTap` callback is invoked

### Requirement: FeatureType provides background image asset path
The `FeatureTypeX` extension SHALL expose a `String get backgroundImage` getter returning the local asset path for each feature type's illustrative background image.

#### Scenario: Each feature type returns a distinct asset path
- **WHEN** `backgroundImage` is accessed on any `FeatureType` value
- **THEN** a non-empty string asset path is returned, unique per type
