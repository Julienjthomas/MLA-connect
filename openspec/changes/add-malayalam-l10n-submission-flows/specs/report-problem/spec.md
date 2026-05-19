## MODIFIED Requirements

### Requirement: ReportCategory labels are localized
The `ReportCategory.label` property SHALL return a locale-aware string via `AppStrings` rather than a hardcoded English string, so category chip labels display in the user's selected language.

#### Scenario: Category labels in Malayalam
- **WHEN** the user locale is `ml`
- **THEN** `ReportCategory.road.label` SHALL return "റോഡ് കേടുപാടുകൾ"
- **THEN** `ReportCategory.water.label` SHALL return "ജലവിതരണം"
- **THEN** `ReportCategory.electricity.label` SHALL return "വൈദ്യുതി"
- **THEN** `ReportCategory.streetlight.label` SHALL return "തെരുവ് വിളക്ക്"
- **THEN** `ReportCategory.drainage.label` SHALL return "ഡ്രെയിനേജ്"
- **THEN** `ReportCategory.waste.label` SHALL return "മാലിന്യ നിർമ്മാർജ്ജനം"
- **THEN** `ReportCategory.safety.label` SHALL return "പൊതു സുരക്ഷ"
- **THEN** `ReportCategory.other.label` SHALL return "മറ്റുള്ളവ"

#### Scenario: Category labels in English
- **WHEN** the user locale is `en`
- **THEN** `ReportCategory.road.label` SHALL return "Road Damage"
- **THEN** existing English category labels are unchanged
