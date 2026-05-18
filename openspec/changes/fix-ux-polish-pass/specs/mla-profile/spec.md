## ADDED Requirements

### Requirement: MLA profile is fully functional
The MLA profile screen SHALL render real data for the user's MLA (name, photo, party, constituency, contact links, About text) with no placeholder or "coming soon" sections.

#### Scenario: User opens MLA profile
- **WHEN** an authenticated user opens the MLA profile screen
- **THEN** the screen SHALL display the MLA's real name, photo, party, constituency, and contact actions
- **THEN** no placeholder text SHALL be visible

### Requirement: About MLA section is populated
The MLA profile SHALL include an "About MLA" section containing a non-empty biographical description sourced from the MLA record.

#### Scenario: About section visible
- **WHEN** the MLA profile renders for an MLA whose `about` field is set
- **THEN** the About section SHALL display the full text

#### Scenario: About section fallback
- **WHEN** the MLA's `about` field is empty
- **THEN** the section SHALL display a short fallback description (e.g. constituency-based) rather than an empty card

## REMOVED Requirements

### Requirement: Issues Resolved analytics on MLA profile
**Reason**: Stakeholder request — analytics like "Issues Resolved" do not belong on the MLA profile.
**Migration**: Remove the analytics widget block from `mla_detail_view.dart`. No data migration required; underlying data sources may remain for use elsewhere.
