## ADDED Requirements

### Requirement: MLA profile resolves from active assembly constituency
The MLA profile feature SHALL load `MlaModel` (name, photo, bio, phone, office address, etc.) for the assembly constituency currently associated with the signed-in user’s profile.

#### Scenario: User switches constituency context
- **WHEN** the user’s `assembly_constituency_id` updates after a product-supported change flow
- **THEN** subsequent opens of the MLA profile use the MLA row bound to that constituency

#### Scenario: Consistent MLA with home
- **WHEN** the Home hero and MLA profile are both opened in the same session
- **THEN** they reference the same MLA identity for the active constituency
