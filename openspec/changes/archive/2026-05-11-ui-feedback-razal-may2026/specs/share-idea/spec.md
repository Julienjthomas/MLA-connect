## MODIFIED Requirements

### Requirement: Required idea inputs
The Details step SHALL require: topic (or custom topic text when "Other" is selected), title, description. The Impact step SHALL require: benefits and at least one beneficiary group.

#### Scenario: Missing benefits
- **WHEN** the user leaves Benefits blank on the Impact step
- **THEN** advance is blocked

#### Scenario: Other topic requires custom input
- **WHEN** the user selects "Other" as the topic
- **THEN** a text input field appears and the user SHALL enter a custom topic before advancing

#### Scenario: Custom topic validation
- **WHEN** "Other" is selected and the custom topic field is empty
- **THEN** advance is blocked with a validation message
