## MODIFIED Requirements

### Requirement: User-facing labels use "issue" not "report"
All user-facing string values that previously said "report" or "reports" (in both English and Malayalam locales) SHALL be updated to say "issue" or "issues" respectively. ARB key identifiers SHALL remain unchanged.

#### Scenario: Activity tab label
- **WHEN** the user opens the Activity screen
- **THEN** the tab that lists submitted issues SHALL display "Issues" (English) or "പ്രശ്നങ്ങൾ" (Malayalam), not "Reports"

#### Scenario: Empty state headline
- **WHEN** the user has no submitted issues
- **THEN** the empty state heading SHALL read "No Issues Yet" (English) or equivalent Malayalam text

#### Scenario: Community impact stat
- **WHEN** the community impact card is shown on the Home screen
- **THEN** the stat label SHALL read "Issues" (English) or equivalent Malayalam, not "Reports"

#### Scenario: Activity empty message
- **WHEN** the activity screen shows its empty/onboarding message
- **THEN** the text SHALL say "Report issues, share ideas…" (English) or equivalent Malayalam

## ADDED Requirements

### Requirement: Malayalam strings are complete and accurate
For every ARB key present in `app_en.arb`, a corresponding entry SHALL exist in `app_ml.arb` with an accurate Malayalam translation. No key SHALL fall back silently to English due to a missing Malayalam entry.

#### Scenario: Missing keys added
- **WHEN** `flutter gen-l10n` is run after this change
- **THEN** no warnings about missing Malayalam translations SHALL be emitted for the keys targeted in this change

#### Scenario: Corrected strings render in-app
- **WHEN** the app is run with the device locale set to Malayalam
- **THEN** user-facing strings SHALL display the correct Malayalam text as provided in the change request
