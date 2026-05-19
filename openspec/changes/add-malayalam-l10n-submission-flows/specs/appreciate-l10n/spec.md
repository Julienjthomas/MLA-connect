## ADDED Requirements

### Requirement: Appreciate flow step strings fully localized
Every string rendered in the Appreciate flow (recipient step, message step, visibility step, review step, success step, and the flow app bar) SHALL resolve from the ARB pipeline and display in Malayalam when the user locale is `ml`.

#### Scenario: App bar and recipient step render in Malayalam
- **WHEN** the user opens the Appreciate flow with locale `ml`
- **THEN** the app bar title SHALL display "അഭിനന്ദനം സമർപ്പിക്കുക"
- **THEN** the step heading SHALL display "നിങ്ങൾ ആരെ അഭിനന്ദിക്കുന്നു?"
- **THEN** the step subtitle SHALL display "നിങ്ങളുടെ MLA അല്ലെങ്കിൽ നേരിട്ടുള്ള ജീവനക്കാരനെ തിരഞ്ഞെടുക്കുക."
- **THEN** the Recipient field label SHALL display "സ്വീകർത്താവ് *"
- **THEN** the empty state text SHALL display "ഇതുവരെ സ്വീകർത്താക്കൾ ലഭ്യമല്ല."
- **THEN** the MLA badge SHALL display "MLA"
- **THEN** the related work label SHALL display "ബന്ധപ്പെട്ട ജോലി / പദ്ധതി (ഓപ്ഷണൽ)"
- **THEN** the related work hint SHALL display "ഉദാ. കുറ്റിക്കാട്ടൂർ റോഡ് അറ്റകുറ്റപ്പണി"
- **THEN** the Next button SHALL display "അടുത്തത്: നിങ്ങളുടെ സന്ദേശം →"

#### Scenario: Message step renders in Malayalam
- **WHEN** the user reaches the Message step with locale `ml`
- **THEN** the heading SHALL display "നിങ്ങളുടെ അഭിനന്ദനം"
- **THEN** the subtitle SHALL display "നിങ്ങളുടെ അഭിനന്ദന സന്ദേശം എഴുതുക"
- **THEN** the text field hint SHALL display "ടീം സ്വീകരിച്ച ദ്രുതഗതിയിലുള്ള നടപടി ഞാൻ അഭിനന്ദിക്കുന്നു..."
- **THEN** the photo upload label SHALL display "ഫോട്ടോ / വീഡിയോ ചേർക്കുക (ഓപ്ഷണൽ)"
- **THEN** the Next button SHALL display "അടുത്തത്: ദൃശ്യത →"

#### Scenario: Visibility step renders in Malayalam
- **WHEN** the user reaches the Visibility step with locale `ml`
- **THEN** the heading SHALL display "ദൃശ്യത ഓപ്ഷൻ"
- **THEN** the subtitle SHALL display "നിങ്ങൾ എങ്ങനെ പങ്കിടണമെന്ന് തിരഞ്ഞെടുക്കുക"
- **THEN** the Next button SHALL display "അടുത്തത്: അവലോകനം →"

#### Scenario: Review step renders in Malayalam
- **WHEN** the user reaches the Review step with locale `ml`
- **THEN** the heading SHALL display "നിങ്ങളുടെ അഭിനന്ദനം അവലോകനം ചെയ്യുക"
- **THEN** the subtitle SHALL display "സമർപ്പിക്കുന്നതിന് മുൻപ് പരിശോധിക്കുക"
- **THEN** card titles SHALL display "സ്വീകർത്താവ്", "നിങ്ങളുടെ സന്ദേശം", "ദൃശ്യത"
- **THEN** row labels SHALL display "വിഭാഗം", "ജീവനക്കാരൻ", "ബന്ധപ്പെട്ട ജോലി", "ദൃശ്യത", "അജ്ഞാതം"
- **THEN** boolean values SHALL display "അതെ" / "ഇല്ല"
- **THEN** the submit button SHALL display "അഭിനന്ദനം സമർപ്പിക്കുക"

#### Scenario: Success step renders in Malayalam
- **WHEN** the appreciation is submitted successfully with locale `ml`
- **THEN** the success heading SHALL display "നന്ദി!\nനിങ്ങളുടെ അഭിനന്ദനം\nവിജയകരമായി പങ്കുവെച്ചു."
- **THEN** the success message SHALL display "നിങ്ങളുടെ നല്ല വാക്കുകൾ അവരെ കൂടുതൽ മികച്ചതായി പ്രവർത്തിക്കാൻ പ്രേരിപ്പിക്കും."
- **THEN** the primary button SHALL display "എന്റെ പ്രവർത്തനത്തിലേക്ക് പോകുക"
- **THEN** the secondary button SHALL display "മറ്റൊരു അഭിനന്ദനം അയക്കുക"
