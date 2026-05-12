## MODIFIED Requirements

### Requirement: Four-tab bottom navigation shell
The home shell SHALL present exactly five tabs in this order: Home, Chat, My Activity, Updates, Profile.

#### Scenario: Tab labels and order
- **WHEN** the home shell renders
- **THEN** the bottom navigation shows Home, Chat, My Activity, Updates, Profile from left to right

### Requirement: Home banner — clean minimal style
The MLA hero banner on the Home tab SHALL display only the MLA’s **photo** and **full name**. It SHALL NOT display constituency labels, the literal “MLA” role label, stat counts, location symbols, verified ticks, or background chrome that competes with the photo beyond a simple backdrop.

#### Scenario: Name and photo only
- **WHEN** the home screen renders
- **THEN** the hero shows the MLA portrait and the MLA full name as the primary text

#### Scenario: No constituency label on hero
- **WHEN** the banner renders
- **THEN** no assembly constituency or panchayath string appears on the hero

#### Scenario: No stat counts
- **WHEN** the banner renders
- **THEN** no numeric stat counters (reports, ideas, etc.) are shown on the banner

### Requirement: Language switch sync
The Home tab SHALL NOT show a language toggle in the app bar. Locale changes SHALL be initiated from Profile → Language and SHALL apply globally when saved.

#### Scenario: No home language toggle
- **WHEN** the home page renders
- **THEN** no language toggle widget appears in the Home app bar

#### Scenario: Profile-driven locale updates
- **WHEN** the user changes language under Profile settings
- **THEN** all visible UI strings update without requiring a restart

## ADDED Requirements

### Requirement: Chat tab routes to office messaging
The Chat tab SHALL navigate to the citizen → MLA office messaging experience defined in `mla-office-chat`.

#### Scenario: Chat tab active
- **WHEN** the user selects the Chat tab
- **THEN** the Chat root screen for messaging is displayed
