## MODIFIED Requirements

### Requirement: Collapsing hero with avatar, name, constituency, term
The detail view SHALL use a `SliverAppBar` with `expandedHeight: 240` showing background image, avatar, MLA name, and constituency. The MLA name SHALL be positioned slightly higher than center for better visual balance. No tick/verified mark and no term badge SHALL be shown.

#### Scenario: Hero collapse
- **WHEN** the user scrolls down
- **THEN** the hero collapses to a pinned app bar

#### Scenario: No tick or term badge
- **WHEN** the view renders
- **THEN** no verified checkmark icon and no "Third Term" or any term badge are visible

### Requirement: Call CTA only — no WhatsApp
The view SHALL show a sticky bottom bar with a single Call Office button (opens `tel:` URI). No WhatsApp button SHALL be present.

#### Scenario: Tap Call
- **WHEN** the user taps Call Office
- **THEN** `launchUrl(Uri(scheme: 'tel', path: <phone>))` is invoked

#### Scenario: No share button
- **WHEN** the view renders
- **THEN** no Share action is visible in the app bar or bottom bar

### Requirement: Expandable About MLA section
The About MLA section SHALL be collapsible. By default it shows a truncated preview (2–3 lines). Tapping "Read more" / a chevron expands to full content.

#### Scenario: Expand about
- **WHEN** the user taps the expand control
- **THEN** the full bio text is revealed with animation

#### Scenario: Collapse about
- **WHEN** the user taps the collapse control while expanded
- **THEN** the text returns to truncated preview

### Requirement: Educational details in About section
The About section SHALL include the MLA's educational background (degree, institution) if present in `MlaModel`.

#### Scenario: Education present
- **WHEN** `MlaModel.education` is non-null
- **THEN** the education line renders beneath the bio

#### Scenario: Education absent
- **WHEN** `MlaModel.education` is null
- **THEN** no education row renders

### Requirement: Office address in contact section
The view SHALL display the MLA's office address below the call button if present in `MlaModel`.

#### Scenario: Address shown
- **WHEN** `MlaModel.officeAddress` is non-null
- **THEN** the address text is visible in the contact area

## REMOVED Requirements

### Requirement: Call and WhatsApp CTAs
**Reason**: WhatsApp removed per UX feedback; replaced by Call-only CTA requirement above.
**Migration**: Remove WhatsApp button from sticky bottom bar; keep Call button.

### Requirement: Initiatives list with progress
**Reason**: Constituency Initiatives section removed per UX feedback — not needed on this page.
**Migration**: Remove `MlaModel.initiatives` rendering from the detail view.
