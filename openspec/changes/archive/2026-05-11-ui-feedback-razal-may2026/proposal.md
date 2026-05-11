## Why

User feedback from Mohammed Razal (May 2026) identified UX issues across 8 screens — visual clutter, broken interactions, missing affordances, and layout problems. Addressing these improves usability and polish before wider rollout.

## What Changes

**Home Page**
- Increase font sizes; differentiate "MLA" label style from MLA name
- Remove tick mark, location symbol, and stat counts from banner
- Reduce banner color intensity
- Fix language switch sync and alignment bug
- Shrink four main option tiles to fit without scroll; move Appreciate to 4th position
- Replace Suggest Improvement icon (distinct from app logo)
- Rename "MLA Activity" → "Updates"; wire "View All" to Updates Listing page
- Handle long update titles with overflow; add clickable images to update tiles
- Make Hall of Excellence banner clickable → Achievements Listing page
- Add achievement input/creation provision

**MLA Info Page**
- Nudge MLA name upward for alignment
- Remove tick mark, Share option, "Third Term" tag
- Remove Constituency Initiatives section
- Make About MLA section expandable/collapsible
- Add educational details and office address fields
- Remove WhatsApp contact option

**Report Problem Page**
- Remove location option from Gradual Update tab
- Switch category selection to chip/tab style (not dropdown)
- Increase description character limit (500 → 1500)
- Expand description box; reduce vertical space of other fields
- Enable voice input/recording for description
- Cap media uploads at 10 files
- Inline location capture (remove separate location page)
- Make Panchayath and Ward fields dropdowns
- Remove GPS icon and hint text from location description
- Remove "Pin on Map" option
- Fix broken Submit action

**Suggest Improvement Page**
- Remove GPS icon from location field

**Submit Appreciation Page**
- Remove duplicate anonymous option in visibility section
- Dismiss keyboard on tap outside any text field

**Share Idea Page**
- Show custom text input when "Other" is selected as topic

**My Activity Page**
- Remove calendar icon

**Updates Page**
- Enable Like action on updates
- Remove duplicate Share option in update detail view

## Capabilities

### New Capabilities
- `voice-input`: Reusable voice recording widget for description fields

### Modified Capabilities
- `mla-profile`: Add education, office address; remove WhatsApp; expandable About section; remove tick/share/term tag/initiatives
- `report-problem`: Inline location, dropdown geo fields, voice input, media cap, bigger description, fix submit
- `suggest-improvement`: Remove GPS icon
- `appreciation`: Fix duplicate anonymous visibility option; keyboard dismiss behavior
- `share-idea`: Custom topic input when "Other" selected
- `updates-feed`: Like action, remove duplicate share, clickable images, long title handling, View All routing
- `my-activity`: Remove calendar icon
- `shell-navigation`: Home page banner/tile/font/color/language/logo fixes; Hall of Excellence routing; achievement input

## Impact

- Affected screens: HomeView, MlaProfileView, ReportProblemView, SuggestImprovementView, AppreciationView, ShareIdeaView, MyActivityView, UpdatesView, UpdateDetailView
- New widget: VoiceInputWidget
- Geo data: Panchayath/Ward dropdowns require static or API-backed data source
- Routing: Hall of Excellence → AchievementsListingPage; Updates View All → UpdatesListingPage
- No breaking API changes; submit fix may require backend investigation
