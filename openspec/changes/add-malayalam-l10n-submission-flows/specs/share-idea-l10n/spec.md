## ADDED Requirements

### Requirement: Share Idea flow step strings fully localized
Every string rendered in the Share Idea flow (details step, impact step, visibility step, review step, success step, and the flow app bar) SHALL resolve from the ARB pipeline and display in Malayalam when the user locale is `ml`.

#### Scenario: Details step renders in Malayalam
- **WHEN** the user opens the Share Idea flow with locale `ml`
- **THEN** the app bar title SHALL display "ആശയം പങ്കിടുക"
- **THEN** the step heading SHALL display "ആശയ വിശദാംശങ്ങൾ"
- **THEN** the step subtitle SHALL display "നിങ്ങളുടെ ആശയം പറയൂ"
- **THEN** the topic label SHALL display "നിങ്ങളുടെ ആശയം ഏത് വിഷയത്തെക്കുറിച്ചാണ്? (വിഷയം) *"
- **THEN** the custom topic label SHALL display "ഇഷ്‌ടാനുസൃത വിഷയം *"
- **THEN** the custom topic hint SHALL display "നിങ്ങളുടെ വിഷയം നൽകുക"
- **THEN** the title label SHALL display "ആശയത്തിന്റെ തലക്കെട്ട് *"
- **THEN** the title hint SHALL display "ഉദാ. നിങ്ങളുടെ പ്രദേശത്തിന് ഒരു സ്മാർട്ട് ഡ്രെയിനേജ് സിസ്റ്റം"
- **THEN** the description label SHALL display "നിങ്ങളുടെ ആശയം വിശദമായി വിവരിക്കുക"
- **THEN** the description hint SHALL display "എന്റെ ആശയം ഒരു സ്മാർട്ട് ഡ്രെയിനേജ് സിസ്റ്റം നിർമ്മിക്കുകയാണ്..."
- **THEN** the Next button SHALL display "അടുത്തത്: ആഘാതവും നേട്ടങ്ങളും →"

#### Scenario: Impact step renders in Malayalam
- **WHEN** the user reaches the Impact step with locale `ml`
- **THEN** the heading SHALL display "പ്രധാന നേട്ടങ്ങളും പ്രതീക്ഷിക്കുന്ന ആഘാതവും"
- **THEN** the subtitle SHALL display "സാധ്യമായ ആഘാതം മനസ്സിലാക്കാൻ സഹായിക്കുക"
- **THEN** the benefits label SHALL display "മണ്ഡലത്തിനുള്ള 2–3 പ്രധാന ഗുണങ്ങൾ പട്ടികപ്പെടുത്തുക *"
- **THEN** the benefits hint SHALL display "• താഴ്ന്ന പ്രദേശങ്ങളിൽ വെള്ളപ്പൊക്കം കുറയ്ക്കുന്നു\n• പൊതുജനാരോഗ്യം സംരക്ഷിക്കുന്നു..."
- **THEN** the beneficiaries label SHALL display "ഈ ആശയത്തിൽ നിന്ന് ആർക്ക് പ്രയോജനം ലഭിക്കും? *"
- **THEN** the resources label SHALL display "ആവശ്യമായ വിഭവങ്ങൾ (ഓപ്ഷണൽ)"
- **THEN** the resources hint SHALL display "ശ്രേണി തിരഞ്ഞെടുക്കുക"
- **THEN** the Next button SHALL display "അടുത്തത്: ദൃശ്യത →"

#### Scenario: Visibility step renders in Malayalam
- **WHEN** the user reaches the Visibility step with locale `ml`
- **THEN** the heading SHALL display "ദൃശ്യതയും സഹകരണവും"
- **THEN** the subtitle SHALL display "നിങ്ങളുടെ ആശയം എങ്ങനെ പങ്കിടണമെന്ന് തിരഞ്ഞെടുക്കുക"
- **THEN** the field label SHALL display "ദൃശ്യത ഓപ്ഷൻ *"
- **THEN** the discussion toggle label SHALL display "സമൂഹ ചർച്ച അനുവദിക്കുക"
- **THEN** the discussion toggle subtitle SHALL display "ആളുകൾക്ക് അഭിപ്രായം പറയാനും മെച്ചപ്പെടുത്തലുകൾ നിർദ്ദേശിക്കാനും കഴിയും"
- **THEN** the contact toggle label SHALL display "MLA ഓഫീസ് എന്നെ ബന്ധപ്പെടുന്നത് അനുവദിക്കുക"
- **THEN** the contact toggle subtitle SHALL display "MLA ഓഫീസിന് കൂടുതൽ വിവരങ്ങൾക്ക് ബന്ധപ്പെടാൻ കഴിയും"
- **THEN** the Next button SHALL display "അടുത്തത്: ആശയം അവലോകനം ചെയ്യുക →"

#### Scenario: Review step renders in Malayalam
- **WHEN** the user reaches the Review step with locale `ml`
- **THEN** the heading SHALL display "സമർപ്പിക്കുന്നതിന് മുൻപ് ആശയം പരിശോധിക്കുക"
- **THEN** card titles SHALL display "ആശയ വിശദാംശങ്ങൾ", "ആഘാതവും നേട്ടങ്ങളും", "ദൃശ്യത"
- **THEN** row labels SHALL display "വിഷയം", "തലക്കെട്ട്", "വിവരണം", "നേട്ടങ്ങൾ", "ഗുണഭോക്താക്കൾ", "വിഭവങ്ങൾ", "ദൃശ്യത", "സമൂഹ ചർച്ച", "MLA ബന്ധം"
- **THEN** boolean values SHALL display "പ്രവർത്തനക്ഷമം" / "നിഷ്‌ക്രിയം" and "അതെ" / "ഇല്ല"
- **THEN** the submit button SHALL display "ആശയം സമർപ്പിക്കുക 🚀"
