## ADDED Requirements

### Requirement: Report flow step strings fully localized
Every string rendered in the Report a Problem flow (details step, location step, visibility step, review step, success step, and the flow app bar) SHALL resolve from the ARB pipeline and display in Malayalam when the user locale is `ml`.

#### Scenario: Details step renders in Malayalam
- **WHEN** the user opens the Report a Problem flow with locale set to `ml`
- **THEN** the step heading SHALL display "പ്രശ്നം വിവരിക്കുക"
- **THEN** the step subtitle SHALL display "ദയവായി പ്രശ്നത്തിന്റെ വിശദാംശങ്ങൾ നൽകുക"
- **THEN** the Category field label SHALL display "വിഭാഗം *"
- **THEN** the category hint SHALL display "പ്രശ്ന വിഭാഗം തിരഞ്ഞെടുക്കുക"
- **THEN** the Description field label SHALL display "പ്രശ്ന വിവരണം *"
- **THEN** the description hint SHALL display "പ്രശ്നം വിശദമായി വിവരിക്കുക..."
- **THEN** the location hint SHALL display "പ്രശ്നത്തിന്റെ കൃത്യമായ സ്ഥാനം വിവരിക്കുക"
- **THEN** the Next button SHALL display "അടുത്തത്: അവലോകനം →"

#### Scenario: Location step renders in Malayalam
- **WHEN** the user reaches the Location step with locale `ml`
- **THEN** the heading SHALL display "സ്ഥലം"
- **THEN** the subtitle SHALL display "പ്രശ്നത്തിന്റെ കൃത്യമായ സ്ഥാനം കണ്ടെത്താൻ സഹായിക്കുക"
- **THEN** the Panchayat label SHALL display "പഞ്ചായത്ത്"
- **THEN** the Ward label SHALL display "വാർഡ് *"
- **THEN** the Landmark label SHALL display "ലാൻഡ്മാർക്ക് / പ്രദേശം (ഓപ്ഷണൽ)"
- **THEN** the Location Description label SHALL display "സ്ഥാന വിവരണം *"
- **THEN** the location hint SHALL display "സ്ഥാനം വിവരിക്കുക"
- **THEN** the GPS note SHALL display "GPS ഉപയോഗിക്കാൻ ലൊക്കേഷൻ ഐക്കൺ ടാപ്പ് ചെയ്യുക"
- **THEN** the map pin text SHALL display "മാപ്പിൽ പിൻ ചെയ്യാൻ ടാപ്പ് ചെയ്യുക"
- **THEN** the Contact Number label SHALL display "ബന്ധപ്പെടാനുള്ള നമ്പർ (ഓപ്ഷണൽ)"
- **THEN** the Next button SHALL display "അടുത്തത്: അവലോകനം →"

#### Scenario: Visibility step renders in Malayalam
- **WHEN** the user reaches the Visibility step with locale `ml`
- **THEN** the heading SHALL display "ദൃശ്യത"
- **THEN** the subtitle SHALL display "ഈ റിപ്പോർട്ട് ആർക്ക് കാണാൻ കഴിയുമെന്ന് തിരഞ്ഞെടുക്കുക"
- **THEN** the field label SHALL display "ദൃശ്യത ഓപ്ഷൻ *"
- **THEN** the Next button SHALL display "അടുത്തത്: അവലോകനം →"

#### Scenario: Review step renders in Malayalam
- **WHEN** the user reaches the Review step with locale `ml`
- **THEN** the heading SHALL display "റിപ്പോർട്ട് പരിശോധിക്കുക"
- **THEN** the subtitle SHALL display "സമർപ്പിക്കുന്നതിന് മുൻപ് റിപ്പോർട്ട് പരിശോധിക്കുക"
- **THEN** section labels SHALL display "പ്രശ്ന വിശദാംശങ്ങൾ", "സ്ഥലം"
- **THEN** row labels SHALL display "വിഭാഗം", "തലക്കെട്ട്", "വിവരണം", "ദൃശ്യത", "ലാൻഡ്മാർക്ക്", "ബന്ധപ്പെടുക"
- **THEN** the submit button SHALL display "റിപ്പോർട്ട് സമർപ്പിക്കുക"

### Requirement: ReportCategory labels localized
The `ReportCategory.label` property SHALL return the Malayalam category name when the current locale is `ml`.

#### Scenario: Category chip labels in Malayalam
- **WHEN** the details step renders category chips with locale `ml`
- **THEN** the chip labels SHALL display: "റോഡ് കേടുപാടുകൾ", "ജലവിതരണം", "വൈദ്യുതി", "തെരുവ് വിളക്ക്", "ഡ്രെയിനേജ്", "മാലിന്യ നിർമ്മാർജ്ജനം", "പൊതു സുരക്ഷ", "മറ്റുള്ളവ"
