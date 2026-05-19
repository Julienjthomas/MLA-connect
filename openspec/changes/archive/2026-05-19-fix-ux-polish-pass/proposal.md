## Why

Stakeholder review surfaced a batch of polish issues spanning Home, Report, Ideas, Appreciation, Profile, MLA Profile, and Malayalam localization. Fixing them together raises the perceived quality of the app before the next demo and unblocks downstream flows (Help/FAQ, Privacy Policy, Contact MLA Office) that are currently stubs.

## What Changes

**Home (first page)**
- Make all four quick-action tile descriptions fully visible (no truncation); fix "Suggest Improvement" label clipping.
- Make the bottom Events section tappable (route to events list / detail).
- Add one more scrollable content section to make the home feel richer (e.g. community impact / recent activity strip).

**Report Problem**
- Move voice input affordance to the bottom-right corner of the description text field.
- Generate Report Reference ID as a random UUID (v4) instead of any current sequential / placeholder format.
- Replace inline voice-into-description with a separate "Insert Voice Message" attachment option, parallel to image upload.

**Private Idea Submission**
- Final confirmation step must not claim a private idea is visible to community. Show visibility-aware copy ("Your public ideas will be visible to the community" only when public; private path gets private-appropriate copy).

**Appreciation**
- Restrict appreciation recipient selection to the MLA and direct staff members only.

**Localization**
- Complete Malayalam (`app_ml.arb`) translations; audit for missing/untranslated keys vs `app_en.arb`.

**My Profile**
- Implement Help & FAQ screen.
- Implement Privacy Policy screen.
- Implement Contact MLA Office screen.

**MLA Profile**
- Fully functional MLA profile page.
- Complete the "About MLA" description section (data + UI).
- Remove "Issues Resolved" / similar analytics counters.
- Optionally add a photo gallery section.

## Capabilities

### New Capabilities
- `help-and-faq`: Static/dynamic Help & FAQ screen reachable from profile.
- `privacy-policy`: Privacy policy screen reachable from profile.
- `contact-mla-office`: Contact MLA Office screen (phone/email/address/links) from profile.
- `mla-photo-gallery`: Optional photo gallery section on MLA profile.

### Modified Capabilities
- `home-quick-actions`: Tile description visibility + label rendering rules.
- `engagement-layer`: Bottom Events section becomes tappable; add one additional content section.
- `report-problem`: UUID reference ID + voice input position + separate voice attachment.
- `voice-input`: Becomes a standalone attachment option, not inline-in-description.
- `share-idea`: Visibility-aware success/confirmation copy.
- `appreciation`: Recipient scope limited to MLA + direct staff.
- `mla-profile`: About MLA filled, analytics removed, gallery hook.
- `profile-settings`: Wire Help & FAQ, Privacy Policy, Contact MLA Office entries to real screens.

## Impact

- Code: `lib/features/home/**`, `lib/features/report/**`, `lib/features/ideas/**`, `lib/features/appreciation/**`, `lib/features/profile/**`, `lib/features/mla/**`, `lib/l10n/app_ml.arb`, `lib/routes/**`.
- Dependencies: add `uuid` package if not already present (for v4 reference IDs).
- Data: appreciation recipient list source must expose MLA + staff only; MLA "About" content source.
- Risk: low — mostly additive UI work and copy/route fixes; no schema migrations.
