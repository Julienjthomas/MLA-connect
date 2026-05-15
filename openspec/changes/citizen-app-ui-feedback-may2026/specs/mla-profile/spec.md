## ADDED Requirements

### Requirement: Home MLA hero banner presentation
The home screen SHALL render an MLA hero banner above the action grid when MLA profile data is loaded. The banner SHALL show the MLA photo, name, and constituency or role context, and SHALL use elevated visual treatment (gradient, pattern, or imagery) beyond a flat color block. Tapping the banner SHALL navigate to MLA detail.

#### Scenario: MLA data loaded
- **WHEN** `HomeController` provides a non-null `MlaModel`
- **THEN** the hero banner renders with photo and name and is tappable

#### Scenario: Loading state
- **WHEN** MLA data is not yet available
- **THEN** the home screen shows a loading placeholder in the hero region without crashing

#### Scenario: Navigate to detail
- **WHEN** the user taps the home MLA hero banner
- **THEN** `Routes.mlaDetail` is pushed
