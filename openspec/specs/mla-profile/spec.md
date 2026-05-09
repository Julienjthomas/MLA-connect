## ADDED Requirements

### Requirement: Read-only MLA detail view
The MLA detail screen SHALL render data from `mla_profile` (or `MlaModel.placeholder` fallback) in a single scroll view.

#### Scenario: Open from home
- **WHEN** the user taps the MLA hero banner on Home
- **THEN** `Routes.mlaDetail` is pushed and the detail view renders

### Requirement: Collapsing hero with avatar, name, constituency, term
The detail view SHALL use a `SliverAppBar` with `expandedHeight: 240` showing background image, avatar, MLA name, constituency, and term badge.

#### Scenario: Hero collapse
- **WHEN** the user scrolls down
- **THEN** the hero collapses to a pinned app bar

### Requirement: Stats row
The detail view SHALL show four stat cards: issues resolved, active projects, appreciations, ideas implemented — each with a feature accent color.

#### Scenario: Stat values
- **WHEN** the view renders
- **THEN** each stat shows the corresponding value from `MlaModel.stats`

### Requirement: Initiatives list with progress
The view SHALL list `MlaModel.initiatives`, each with title, description, optional image, and a `LinearProgressIndicator` showing percent complete.

#### Scenario: Progress display
- **WHEN** an initiative has `progress = 0.6`
- **THEN** the bar shows 60% and the label shows "60%"

### Requirement: Call and WhatsApp CTAs
The view SHALL show a sticky bottom bar with two buttons: Call Office (opens `tel:` URI) and WhatsApp (opens `https://wa.me/<digits>` in external app).

#### Scenario: Tap Call
- **WHEN** the user taps Call Office
- **THEN** `launchUrl(Uri(scheme: 'tel', path: <phone>))` is invoked

#### Scenario: Tap WhatsApp
- **WHEN** the user taps WhatsApp
- **THEN** `launchUrl(..., mode: LaunchMode.externalApplication)` opens WhatsApp with the MLA's number
