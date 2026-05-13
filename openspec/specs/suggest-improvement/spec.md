## Purpose

Define the suggest-improvement submission flow and inputs.

## Requirements

### Requirement: Required improvement inputs
The Suggestion step SHALL require: suggestion text and department. The Location step SHALL require: location text. No GPS icon SHALL appear in any location field in this flow.

#### Scenario: Missing suggestion text
- **WHEN** suggestion is empty
- **THEN** advance is blocked

#### Scenario: No GPS icon
- **WHEN** any location field renders in the improvement flow
- **THEN** no GPS icon appears as a field prefix or suffix
