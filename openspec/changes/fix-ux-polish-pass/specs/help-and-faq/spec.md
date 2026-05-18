## ADDED Requirements

### Requirement: Help & FAQ screen displays Q&A content
The Help & FAQ screen SHALL display a list of frequently asked questions and their answers, scrollable, with each question expandable or always-visible.

#### Scenario: User opens Help & FAQ
- **WHEN** the user navigates to Help & FAQ
- **THEN** a list of at least 3 question/answer pairs SHALL render
- **THEN** the screen SHALL have an app bar with a title and back navigation

### Requirement: Help & FAQ supports localization
The screen content SHALL render in the user's selected app locale (English or Malayalam).

#### Scenario: Malayalam locale
- **WHEN** the user has Malayalam selected and opens Help & FAQ
- **THEN** the questions and answers SHALL render in Malayalam
