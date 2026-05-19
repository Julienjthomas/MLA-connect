## ADDED Requirements

### Requirement: Suggest Improvement flow step strings fully localized
Every string rendered in the Suggest Improvement flow (suggestion step, location step, review step, success step, and the flow app bar) SHALL resolve from the ARB pipeline and display in Malayalam when the user locale is `ml`.

#### Scenario: App bar and suggestion step render in Malayalam
- **WHEN** the user opens the Suggest Improvement flow with locale `ml`
- **THEN** the app bar title SHALL display "മെച്ചപ്പെടുത്തൽ നിർദ്ദേശിക്കുക"
- **THEN** the step heading SHALL display "നിർദ്ദേശ വിശദാംശങ്ങൾ"
- **THEN** the step subtitle SHALL display "നിങ്ങളുടെ മെച്ചപ്പെടുത്തൽ നിർദ്ദേശം പങ്കിടുക"
- **THEN** the department label SHALL display "ലക്ഷ്യ വകുപ്പ് (ഓപ്ഷണൽ)"
- **THEN** the department hint SHALL display "വകുപ്പ് തിരഞ്ഞെടുക്കുക"
- **THEN** the suggestion field label SHALL display "നിങ്ങളുടെ നിർദ്ദേശം *"
- **THEN** the suggestion hint SHALL display "നിങ്ങളുടെ മെച്ചപ്പെടുത്തൽ നിർദ്ദേശം വിശദമായി വിവരിക്കുക..."
- **THEN** the Next button SHALL display "അടുത്തത്: സ്ഥലം →"

#### Scenario: Location step renders in Malayalam
- **WHEN** the user reaches the Location step with locale `ml`
- **THEN** the heading SHALL display "സ്ഥലം (ഓപ്ഷണൽ)"
- **THEN** the subtitle SHALL display "ഈ മെച്ചപ്പെടുത്തൽ എവിടെ നടപ്പിലാക്കണം?"
- **THEN** the location label SHALL display "സ്ഥലം / പ്രദേശം"
- **THEN** the location hint SHALL display "ഉദാ. പ്രധാന ചന്തയ്ക്ക് സമീപം"
- **THEN** the landmark label SHALL display "ലാൻഡ്മാർക്ക് (ഓപ്ഷണൽ)"
- **THEN** the landmark hint SHALL display "സമീപത്തുള്ള ലാൻഡ്മാർക്ക്"
- **THEN** the Next button SHALL display "അടുത്തത്: അവലോകനം →"

#### Scenario: Review step renders in Malayalam
- **WHEN** the user reaches the Review step with locale `ml`
- **THEN** the heading SHALL display "നിങ്ങളുടെ നിർദ്ദേശം അവലോകനം ചെയ്യുക"
- **THEN** the subtitle SHALL display "സമർപ്പിക്കുന്നതിന് മുൻപ് പരിശോധിക്കുക"
- **THEN** the card title SHALL display "നിർദ്ദേശ വിശദാംശങ്ങൾ"
- **THEN** row labels SHALL display "വകുപ്പ്", "നിർദ്ദേശം", "സ്ഥലം", "ലാൻഡ്മാർക്ക്"
- **THEN** the submit button SHALL display "നിർദ്ദേശം സമർപ്പിക്കുക"

#### Scenario: Success step renders in Malayalam
- **WHEN** the suggestion is submitted successfully with locale `ml`
- **THEN** the success heading SHALL display "നിങ്ങളുടെ നിർദ്ദേശം\nവിജയകരമായി സമർപ്പിച്ചു!"
- **THEN** the success message SHALL display "ഞങ്ങളുടെ ടീം നിങ്ങളുടെ നിർദ്ദേശം അവലോകനം ചെയ്ത് ഉചിതമായ നടപടി സ്വീകരിക്കും."
- **THEN** the primary button SHALL display "ഹോമിലേക്ക് പോകുക"
