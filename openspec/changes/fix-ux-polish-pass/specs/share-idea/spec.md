## ADDED Requirements

### Requirement: Confirmation copy honors idea visibility
The idea submission success step SHALL display visibility-aware confirmation copy. Private ideas SHALL NOT show any text stating the idea is visible to the community.

#### Scenario: Public idea success
- **WHEN** the user submits an idea with visibility set to public
- **THEN** the success step SHALL display copy clarifying that public ideas will be visible to the community (e.g. "Your public ideas will be visible to the community.")

#### Scenario: Private idea success
- **WHEN** the user submits an idea with visibility set to private
- **THEN** the success step SHALL NOT claim the idea is visible to the community
- **THEN** the success step SHALL display private-appropriate copy (e.g. "Your idea has been sent privately to the MLA office.")
