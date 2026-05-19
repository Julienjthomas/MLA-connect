## 1. ARB Keys — English (app_en.arb)

- [x] 1.1 Add Report flow keys: `reportDescribeProblem`, `reportDescribeSubtitle`, `reportCategoryLabel`, `reportCategoryHint`, `reportDescriptionLabel`, `reportDescriptionHint`, `reportLocationHint`, `reportNextReview`
- [x] 1.2 Add Report Location step keys: `reportLocationHeading`, `reportLocationSubtitle`, `reportPanchayatLabel`, `reportWardLabel`, `reportLandmarkLabel`, `reportLocationDescLabel`, `reportLocationDescHint`, `reportGpsNote`, `reportMapPin`, `reportContactLabel`, `reportContactHint`
- [x] 1.3 Add Report Visibility step keys: `reportVisibilityHeading`, `reportVisibilitySubtitle`, `reportVisibilityFieldLabel`
- [x] 1.4 Add Report Review step keys: `reportReviewHeading`, `reportReviewSubtitle`, `reportReviewSectionDetails`, `reportReviewSectionLocation`, `reportReviewRowCategory`, `reportReviewRowTitle`, `reportReviewRowDescription`, `reportReviewRowVisibility`, `reportReviewRowLandmark`, `reportReviewRowContact`
- [x] 1.5 Add ReportCategory label keys: `categoryRoadDamage`, `categoryStreetlight`, `categoryDrainage`, `categoryWasteManagement`, `categoryPublicSafety` (verify `categoryWater`, `categoryElectricity`, `categoryOther` already exist)
- [x] 1.6 Add Appreciation flow keys: `appreciateWhoHeading`, `appreciateWhoSubtitle`, `appreciateRecipientLabel`, `appreciateNoRecipients`, `appreciateMlaBadge`, `appreciateRelatedWorkLabel`, `appreciateRelatedWorkHint`, `appreciateNextMessage`
- [x] 1.7 Add Appreciation Message step keys: `appreciateMessageHeading`, `appreciateMessageSubtitle`, `appreciateMessageHint`, `appreciateAddPhotoLabel`, `appreciateNextVisibility`
- [x] 1.8 Add Appreciation Visibility step keys: `appreciateVisibilityHeading`, `appreciateVisibilitySubtitle`, `appreciateNextReview`
- [x] 1.9 Add Appreciation Review step keys: `appreciateReviewHeading`, `appreciateReviewSubtitle`, `appreciateCardRecipient`, `appreciateCardMessage`, `appreciateCardVisibility`, `appreciateRowStaff`, `appreciateRowRelatedWork`, `appreciateRowAnonymous`, `appreciateSubmitBtn`
- [x] 1.10 Add Appreciation Success step keys: `appreciateSuccessMsg`, `appreciateSuccessMotivation`, `appreciateSendAnother`
- [x] 1.11 Add Idea Details step keys: `ideaDetailsHeading`, `ideaDetailsSubtitle`, `ideaTopicLabel`, `ideaCustomTopicLabel`, `ideaCustomTopicHint`, `ideaTitleLabel`, `ideaTitleHint`, `ideaDescLabel`, `ideaDescHint`, `ideaNextImpact`
- [x] 1.12 Add Idea Impact step keys: `ideaImpactHeading`, `ideaImpactSubtitle`, `ideaBenefitsLabel`, `ideaBenefitsHint`, `ideaBeneficiariesLabel`, `ideaResourcesLabel`, `ideaResourcesHint`, `ideaNextVisibility`
- [x] 1.13 Add Idea Visibility step keys: `ideaVisibilityHeading`, `ideaVisibilitySubtitle`, `ideaVisibilityFieldLabel`, `ideaDiscussionLabel`, `ideaDiscussionSubtitle`, `ideaContactLabel`, `ideaContactSubtitle`, `ideaNextReview`
- [x] 1.14 Add Idea Review step keys: `ideaReviewHeading`, `ideaCardDetails`, `ideaCardImpact`, `ideaCardVisibility`, `ideaRowTopic`, `ideaRowBenefits`, `ideaRowBeneficiaries`, `ideaRowResources`, `ideaRowDiscussion`, `ideaRowContact`, `ideaEnabled`, `ideaDisabled`, `ideaSubmitBtn`
- [x] 1.15 Add Improvement flow keys: `improveHeading`, `improveSubtitle`, `improveDeptLabel`, `improveDeptHint`, `improveSuggestionLabel`, `improveSuggestionHint`, `improveNextLocation`
- [x] 1.16 Add Improvement Location step keys: `improveLocationHeading`, `improveLocationSubtitle`, `improveLocationLabel`, `improveLocationHint`, `improveLandmarkLabel`, `improveLandmarkHint`, `improveNextReview`
- [x] 1.17 Add Improvement Review step keys: `improveReviewHeading`, `improveReviewSubtitle`, `improveCardDetails`, `improveRowDept`, `improveRowSuggestion`, `improveRowLocation`, `improveRowLandmark`, `improveSubmitBtn`
- [x] 1.18 Add Improvement Success step keys: `improveSuccessMsg`, `improveGoHome`
- [x] 1.19 Add shared keys if not already present: `yesLabel`, `noLabel`, `maximumReached`, `maximumFilesMsg`

## 2. ARB Keys — Malayalam (app_ml.arb)

- [x] 2.1 Add Malayalam translations for all Report flow keys (1.1–1.4) using strings defined in `report-problem-l10n` spec
- [x] 2.2 Add Malayalam translations for all ReportCategory keys (1.5): "റോഡ് കേടുപാടുകൾ", "തെരുവ് വിളക്ക്", "ഡ്രെയിനേജ്", "മാലിന്യ നിർമ്മാർജ്ജനം", "പൊതു സുരക്ഷ"
- [x] 2.3 Add Malayalam translations for all Appreciation flow keys (1.6–1.10) using strings in `appreciate-l10n` spec
- [x] 2.4 Add Malayalam translations for all Idea flow keys (1.11–1.14) using strings in `share-idea-l10n` spec
- [x] 2.5 Add Malayalam translations for all Improvement flow keys (1.15–1.18) using strings in `suggest-improvement-l10n` spec
- [x] 2.6 Add Malayalam translations for shared keys (1.19): "അതെ", "ഇല്ല", "പരമാവധി എത്തി", "പരമാവധി 10 ഫയലുകൾ അനുവദനീയം"

## 3. Regenerate Localizations

- [x] 3.1 Run `flutter gen-l10n` and confirm zero errors — fixes any missing-key build failures
- [x] 3.2 Verify `lib/l10n/app_localizations_ml.dart` contains all new getter methods

## 4. AppStrings Getters

- [x] 4.1 Add static getters in `AppStrings` for all Report flow keys (groups 1.1–1.4)
- [x] 4.2 Add static getters for all ReportCategory label keys (1.5)
- [x] 4.3 Add static getters for all Appreciation flow keys (1.6–1.10)
- [x] 4.4 Add static getters for all Idea flow keys (1.11–1.14)
- [x] 4.5 Add static getters for all Improvement flow keys (1.15–1.18)
- [x] 4.6 Add static getters for shared keys (1.19)

## 5. Enum Localization

- [x] 5.1 Update `ReportCategoryX.label` switch in `app_enums.dart` to use `AppStrings.categoryRoadDamage`, `AppStrings.categoryWater`, `AppStrings.categoryElectricity`, `AppStrings.categoryStreetlight`, `AppStrings.categoryDrainage`, `AppStrings.categoryWasteManagement`, `AppStrings.categoryPublicSafety`, `AppStrings.categoryOther`

## 6. Wire Views — Report Flow

- [x] 6.1 Replace all hardcoded strings in `report_details_step.dart` with `AppStrings.*` getters
- [x] 6.2 Replace all hardcoded strings in `report_location_step.dart` with `AppStrings.*` getters
- [x] 6.3 Replace all hardcoded strings in `report_visibility_step.dart` with `AppStrings.*` getters
- [x] 6.4 Replace all hardcoded strings in `report_review_step.dart` with `AppStrings.*` getters

## 7. Wire Views — Appreciation Flow

- [x] 7.1 Replace all hardcoded strings in `recipient_step.dart` with `AppStrings.*` getters
- [x] 7.2 Replace all hardcoded strings in `message_step.dart` with `AppStrings.*` getters
- [x] 7.3 Replace all hardcoded strings in `visibility_step.dart` (appreciation) with `AppStrings.*` getters
- [x] 7.4 Replace all hardcoded strings in `appreciation_review_step.dart` with `AppStrings.*` getters
- [x] 7.5 Replace all hardcoded strings in `appreciation_success_step.dart` with `AppStrings.*` getters
- [x] 7.6 Replace hardcoded app bar title in `appreciation_flow_view.dart` with `AppStrings.*`

## 8. Wire Views — Idea Flow

- [x] 8.1 Replace all hardcoded strings in `idea_details_step.dart` with `AppStrings.*` getters
- [x] 8.2 Replace all hardcoded strings in `idea_impact_step.dart` with `AppStrings.*` getters
- [x] 8.3 Replace all hardcoded strings in `idea_visibility_step.dart` with `AppStrings.*` getters
- [x] 8.4 Replace all hardcoded strings in `idea_review_step.dart` with `AppStrings.*` getters
- [x] 8.5 Replace hardcoded app bar title in `idea_flow_view.dart` with `AppStrings.*`

## 9. Wire Views — Improvement Flow

- [x] 9.1 Replace all hardcoded strings in `suggestion_step.dart` with `AppStrings.*` getters
- [x] 9.2 Replace all hardcoded strings in `improvement_location_step.dart` with `AppStrings.*` getters
- [x] 9.3 Replace all hardcoded strings in `improvement_review_step.dart` with `AppStrings.*` getters
- [x] 9.4 Replace all hardcoded strings in `improvement_success_step.dart` with `AppStrings.*` getters
- [x] 9.5 Replace hardcoded app bar title in `improvement_flow_view.dart` with `AppStrings.*`

## 10. Verify

- [ ] 10.1 Switch device/simulator locale to Malayalam and manually walk through all four flows — confirm zero English strings visible
- [ ] 10.2 Switch locale back to English and confirm all flows render correctly in English
- [ ] 10.3 Run `flutter build apk --debug` (or `flutter run`) to confirm no compilation errors
