import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../utils/app_locale.dart';

class AppStrings {
  AppStrings._();

  static S get _s => lookupS(Locale(AppLocale.current));

  // App
  static String get appName => _s.appName;
  static String get tagline => _s.tagline;

  // Onboarding
  static String get welcome => _s.welcome;
  static String get welcomeSubtitle => _s.welcomeSubtitle;
  static String get getStarted => _s.continueWithPhone;
  static String get browsePublicUpdates => _s.browsePublicUpdates;
  static String get selectLanguage => _s.selectLanguage;
  static String get chooseLanguage => _s.chooseLanguage;
  static String get continueBtn => _s.continueBtn;

  // Auth
  static String get enterMobile => _s.enterMobile;
  static String get mobileSubtitle => _s.mobileSubtitle;
  static String get sendOtp => _s.sendOtp;
  static String get verifyOtp => _s.verifyOtp;
  static String get otpSentTo => _s.otpSentTo;
  static String get resendOtp => _s.resendOtp;
  static String get resendNow => _s.resendNow;
  static String get changeMobile => _s.changeMobile;
  static String get privacyNote => _s.privacyNote;

  // Panchayat / Ward
  static String get selectPanchayat => _s.selectPanchayat;
  static const selectPanchayatStep = 'Step 1 of 5';
  static String get panchayatHelp => _s.panchayatHelp;
  static String get searchPanchayat => _s.searchPanchayat;
  static String get selectWard => _s.selectWard;
  static const selectWardStep = 'Step 2 of 5';
  static String get chooseWard => _s.chooseWard;
  static String get searchWard => _s.searchWard;

  // Profile setup
  static String get basicProfile => _s.basicProfile;
  static const basicProfileStep = 'Step 3 of 5';
  static String get basicProfileSubtitle => _s.basicProfileSubtitle;
  static String get fullName => _s.fullName;
  static String get emailOptional => _s.emailOptional;

  // Notifications
  static String get notificationPrefs => _s.notificationPrefs;
  static const notificationStep = 'Step 4 of 5';
  static String get notificationSubtitle => _s.notificationSubtitle;
  static String get issueUpdates => _s.issueUpdates;
  static String get issueUpdatesDesc => _s.issueUpdatesDesc;
  static String get mlaAnnouncements => _s.mlaAnnouncements;
  static String get mlaAnnouncementsDesc => _s.mlaAnnouncementsDesc;
  static String get emergencyAlerts => _s.emergencyAlerts;
  static String get emergencyAlertsDesc => _s.emergencyAlertsDesc;
  static String get eventReminders => _s.eventReminders;
  static String get eventRemindersDesc => _s.eventRemindersDesc;

  // Onboarding success
  static String get allSet => _s.allSet;
  static String get allSetSubtitle => _s.allSetSubtitle;
  static String get goToHome => _s.goToHome;

  // Home
  static String get whatWouldYouLike => _s.whatWouldYouLike;
  static String get quickActions => _s.quickActions;
  static String get quickActionIssue => _s.quickActionIssue;
  static String get quickActionIssueSubtitle => _s.quickActionIssueSubtitle;
  static String get quickActionIdea => _s.quickActionIdea;
  static String get quickActionIdeaSubtitle => _s.quickActionIdeaSubtitle;
  static String get quickActionSuggest => _s.quickActionSuggest;
  static String get quickActionSuggestSubtitle => _s.quickActionSuggestSubtitle;
  static String get quickActionAppreciate => _s.quickActionAppreciate;
  static String get quickActionAppreciateSubtitle => _s.quickActionAppreciateSubtitle;
  static String get mlaActivity => _s.mlaActivity;
  static String get viewAll => _s.viewAll;
  static String get hallOfExcellence => _s.hallOfExcellence;
  static String get publicGrievance => _s.publicGrievanceHearing;
  static String get viewDetails => _s.viewDetails;
  // MLA Hero Card
  static String get yourMlaLabel => _s.yourMlaLabel;
  static String get contactOffice => _s.contactOffice;
  static String get messageMla => _s.messageMla;
  static String get meetMla => _s.meetMla;
  // Community Banner
  static String get communityBannerHeadline => _s.communityBannerHeadline;
  static String get communityBannerSubtext => _s.communityBannerSubtext;
  static String get activeIssues => _s.activeIssues;
  static String get inProgress => _s.inProgress;
  static String get issuesResolvedLabel => _s.issuesResolvedLabel;
  // Community Impact
  static String get communityImpactHeader => _s.communityImpactHeader;
  static String get communityImpactTagline => _s.communityImpactTagline;
  static String get issuesResolvedStat => _s.issuesResolvedStat;
  static String get ideasImplementedStat => _s.ideasImplementedStat;
  static String get appreciationsSharedStat => _s.appreciationsSharedStat;
  // FAB
  static String get raiseNewIssue => _s.raiseNewIssue;
  // Status
  static String get statusNew => _s.statusNew;

  // Report
  static String get reportProblem => _s.reportProblem;
  static String get describeIssue => _s.describeIssue;
  static String get addVoiceNote => _s.addVoiceMessage;
  static String get addPhotos => _s.addPhotos;
  static String get selectCategory => _s.selectCategory;
  static String get location => _s.location;
  static String get landmark => _s.landmark;
  static String get gpsLocation => _s.pinLocationOptional;
  static String get contactNumber => _s.contactNumber;
  static String get submitReport => _s.submitReport;
  static String get reportSuccess => _s.reportSuccess;
  static String get reportSuccessMsg => _s.reportSuccessMsg;
  static String get trackInActivity => _s.trackInActivity;
  static String get reportAnother => _s.reportAnother;

  // Appreciation
  static String get appreciateTitle => _s.appreciateTitle;
  static String get recipientCategory => _s.recipientCategory;
  static String get staffName => _s.staffName;
  static String get relatedWork => _s.relatedWork;
  static String get yourAppreciation => _s.yourAppreciation;
  static String get appreciationMsg => _s.appreciationMsg;
  static String get appreciationSuccess => _s.appreciationSuccess;

  // Idea
  static String get shareIdea => _s.shareIdea;
  static String get ideaTitle => _s.ideaTitle;
  static String get ideaDescription => _s.ideaDescription;
  static String get keyBenefits => _s.keyBenefits;
  static String get whoBenefits => _s.whoBenefits;
  static String get estimatedResources => _s.estimatedResources;
  static String get ideaSuccess => _s.ideaSuccess;

  // Improvement
  static String get suggestImprovement => _s.suggestImprovement;
  static String get suggestionDetails => _s.suggestionDetails;
  static String get targetDepartment => _s.targetDepartment;
  static String get improvementSuccess => _s.improvementSuccess;

  // Activity
  static String get myActivity => _s.myActivity;
  static String get trackContributions => _s.trackContributions;
  static String get seeYourImpact => _s.seeYourImpact;
  static String get yourImpact => _s.yourImpact;
  static String get keepItUp => _s.keepItUp;
  static String get chooseOptionToStart => _s.chooseOptionToStart;
  static String get activityTabReports => _s.activityTabReports;
  static String get activityTabIdeas => _s.activityTabIdeas;
  static String get activityTabImprovements => _s.activityTabImprovements;
  static String get activityTabAppreciations => _s.activityTabAppreciations;
  static String get activityTabSaved => _s.activityTabSaved;
  static String get activityFabReport => _s.activityFabReport;
  static String get activityFabIdea => _s.activityFabIdea;
  static String get activityFabImprovement => _s.activityFabImprovement;
  static String get activityFabAppreciation => _s.activityFabAppreciation;
  static String get activityGreatGoing => _s.activityGreatGoing;
  static String activityGreatGoingNamed(String name) => _s.activityGreatGoingNamed(name);
  static String activityContributionsSoFar(int count) => _s.activityContributionsSoFar(count);
  static String get activityCommunityTagline => _s.activityCommunityTagline;
  static String get filterAll => _s.filterAll;
  static String get filterActive => _s.filterActive;
  static String get activityNoMatches => _s.activityNoMatches;
  static String get activityNoReportsWithStatus => _s.activityNoReportsWithStatus;
  static String get activityEmptyHeadline => _s.activityEmptyHeadline;
  static String get activityEmptyMessage => _s.activityEmptyMessage;
  static String activityIdWard(String id, String ward) => _s.activityIdWard(id, ward);
  static String get reportDetail => _s.reportDetail;
  static String get ideaDetail => _s.ideaDetail;
  static String get improvementDetail => _s.improvementDetail;
  static String get appreciationDetail => _s.appreciationDetail;
  static String get reportNotFound => _s.reportNotFound;
  static String get photos => _s.photos;
  static String get statusSubmitted => _s.statusSubmitted;
  static String get statusReview => _s.statusReview;
  static String get statusAssigned => _s.statusAssigned;
  static String get statusInProgress => _s.statusInProgress;
  static String get statusResolved => _s.statusResolved;
  static String get statusClosed => _s.statusClosed;
  static String get statusDescSubmitted => _s.statusDescSubmitted;
  static String get statusDescUnderReview => _s.statusDescUnderReview;
  static String get statusDescAssigned => _s.statusDescAssigned;
  static String get statusDescInProgress => _s.statusDescInProgress;
  static String get statusDescResolved => _s.statusDescResolved;
  static String get statusDescRejected => _s.statusDescRejected;
  static String get needHelp => _s.needHelp;
  static String get needHelpSubtitle => _s.needHelpSubtitle;
  static String get addUpdateComment => _s.addUpdateComment;
  static String get description => _s.description;
  static String get visibilityPublic => _s.visibilityPublic;
  static String get visibilityMlaOnly => _s.visibilityMlaOnly;
  static String get visibilityAnonymous => _s.visibilityAnonymous;
  static String get visibilityPublicDesc => _s.visibilityPublicDesc;
  static String get visibilityMlaOnlyDesc => _s.visibilityMlaOnlyDesc;
  static String get visibilityAnonymousDesc => _s.visibilityAnonymousDesc;

  static String get navHome => _s.navHome;
  static String get navActivity => _s.navActivity;
  static String get navUpdates => _s.navUpdates;
  static String get navProfile => _s.navProfile;
  static String get savedEmptyTitle => _s.savedEmptyTitle;
  static String get savedEmptyMsg => _s.savedEmptyMsg;

  // Updates
  static String get updates => _s.updates;
  static String get recentUpdates => 'Recent Updates';
  static String get stayUpdated => _s.stayUpdated;

  // Profile
  static String get profile => _s.profile;
  static String get editProfile => _s.editProfile;
  static String get changeMobileNumber => _s.changeMobile;
  static String get language => _s.language;
  static String get notifications => _s.notifications;
  static String get helpCenter => _s.helpCenter;
  static String get contactMlaOffice => _s.contactMlaOffice;
  static String get chatWithYourMla => _s.chatWithYourMla;
  static String get aboutApp => _s.aboutApp;
  static String get termsConditions => _s.termsConditions;
  static String get privacyPolicy => _s.privacyPolicy;
  static String get logout => _s.logout;

  // Common
  static String get next => _s.next;
  static String get back => _s.back;
  static String get submit => _s.submit;
  static String get cancel => _s.cancel;
  static String get save => _s.save;
  static String get loading => _s.loading;
  static String get error => _s.error;
  static String get noInternet => _s.noInternet;
  static String get required => _s.required;

  // Feature tiles (home)
  static String get featureReportLabel => _s.featureReportLabel;
  static String get featureReportSubtitle => _s.featureReportSubtitle;
  static String get featureIdeaLabel => _s.featureIdeaLabel;
  static String get featureIdeaSubtitle => _s.featureIdeaSubtitle;
  static String get featureImproveLabel => _s.featureImproveLabel;
  static String get featureImproveSubtitle => _s.featureImproveSubtitle;
  static String get featureAppreciateLabel => _s.featureAppreciateLabel;
  static String get featureAppreciateSubtitle => _s.featureAppreciateSubtitle;

  // Community impact
  static String get communityImpactTitle => _s.communityImpactTitle;
  static String get communityImpactSubtitle => _s.communityImpactSubtitle;
  static String get communityImpactReports => _s.communityImpactReports;
  static String get communityImpactIdeas => _s.communityImpactIdeas;
  static String get communityImpactThanks => _s.communityImpactThanks;

  // Profile + misc
  static String get events => _s.events;
  static String get myProfile => _s.myProfile;
  static String get helpFaq => _s.helpFaq;
  static String get general => _s.general;
  static String get account => _s.account;
  static String get logoutConfirm => _s.logoutConfirm;

  static String get copy => _s.copy;
  static String get done => _s.done;
  static String get addMore => _s.addMore;
  static String get callOffice => _s.callOffice;
  static String get retry => _s.retry;

  static String get contactDetailsUnavailable => _s.contactDetailsUnavailable;
  static String get contactDetailsUnavailableMsg => _s.contactDetailsUnavailableMsg;
  static String get phoneLabel => _s.phoneLabel;
  static String get emailLabel => _s.emailLabel;
  static String get addressLabel => _s.addressLabel;

  static String get aboutMla => _s.aboutMla;
  static String get gallery => _s.gallery;
  static String get mlaDataUnavailable => _s.mlaDataUnavailable;
  static String get mlaOfficeDetailsUnavailable => _s.mlaOfficeDetailsUnavailable;

  // Idea success
  static String get ideaSuccessMsg => _s.ideaSuccessMsg;
  static String get ideaSuccessPublicVisible => _s.ideaSuccessPublicVisible;
  static String get ideaSuccessPublicUpvote => _s.ideaSuccessPublicUpvote;
  static String get ideaSuccessPrivateSent => _s.ideaSuccessPrivateSent;
  static String get ideaSuccessPrivateOnly => _s.ideaSuccessPrivateOnly;
  static String get ideaSuccessTeamReview => _s.ideaSuccessTeamReview;
  static String get goToMyActivity => _s.goToMyActivity;
  static String get submitAnotherIdea => _s.submitAnotherIdea;

  // Report success
  static String get yourReferenceId => _s.yourReferenceId;
  static String get copied => _s.copied;
  static String get referenceIdCopied => _s.referenceIdCopied;
  static String get unableToOpen => _s.unableToOpen;

  // Privacy policy
  static String get privacyLastUpdated => _s.privacyLastUpdated;
  static List<({String title, String body})> get privacySections => [
        (title: _s.privacyIntroTitle, body: _s.privacyIntroBody),
        (title: _s.privacyCollectTitle, body: _s.privacyCollectBody),
        (title: _s.privacyUseTitle, body: _s.privacyUseBody),
        (title: _s.privacySharingTitle, body: _s.privacySharingBody),
        (title: _s.privacyStorageTitle, body: _s.privacyStorageBody),
        (title: _s.privacyChoicesTitle, body: _s.privacyChoicesBody),
        (title: _s.privacyContactTitle, body: _s.privacyContactBody),
      ];

  // Help & FAQ
  static List<({String question, String answer})> get helpFaqs => [
        (question: _s.helpFaqQ1, answer: _s.helpFaqA1),
        (question: _s.helpFaqQ2, answer: _s.helpFaqA2),
        (question: _s.helpFaqQ3, answer: _s.helpFaqA3),
        (question: _s.helpFaqQ4, answer: _s.helpFaqA4),
        (question: _s.helpFaqQ5, answer: _s.helpFaqA5),
        (question: _s.helpFaqQ6, answer: _s.helpFaqA6),
        (question: _s.helpFaqQ7, answer: _s.helpFaqA7),
      ];

  // Report flow — details step
  static String get reportDescribeProblem => _s.reportDescribeProblem;
  static String get reportDescribeSubtitle => _s.reportDescribeSubtitle;
  static String get reportCategoryLabel => _s.reportCategoryLabel;
  static String get reportCategoryHint => _s.reportCategoryHint;
  static String get reportDescriptionLabel => _s.reportDescriptionLabel;
  static String get reportDescriptionHint => _s.reportDescriptionHint;
  static String get reportDetailsLocationHint => _s.reportDetailsLocationHint;
  static String get reportNextReview => _s.reportNextReview;

  // Report flow — location step
  static String get reportLocationSubtitle => _s.reportLocationSubtitle;
  static String get reportPanchayatLabel => _s.reportPanchayatLabel;
  static String get reportWardLabel => _s.reportWardLabel;
  static String get reportLandmarkAreaLabel => _s.reportLandmarkAreaLabel;
  static String get reportLocationDescLabel => _s.reportLocationDescLabel;
  static String get reportLocationDescHint => _s.reportLocationDescHint;
  static String get reportGpsNote => _s.reportGpsNote;
  static String get reportMapPin => _s.reportMapPin;
  static String get reportContactLabel => _s.reportContactLabel;

  // Report flow — visibility step
  static String get reportVisibilityHeading => _s.reportVisibilityHeading;
  static String get reportVisibilitySubtitle => _s.reportVisibilitySubtitle;

  // Report flow — review step
  static String get reportReviewHeading => _s.reportReviewHeading;
  static String get reportReviewSubtitle => _s.reportReviewSubtitle;
  static String get reportReviewSectionDetails => _s.reportReviewSectionDetails;
  static String get reportReviewRowCategory => _s.reportReviewRowCategory;
  static String get reportReviewRowTitle => _s.reportReviewRowTitle;
  static String get reportReviewRowDescription => _s.reportReviewRowDescription;
  static String get reportReviewRowVisibility => _s.reportReviewRowVisibility;
  static String get reportReviewRowLandmark => _s.reportReviewRowLandmark;
  static String get reportReviewRowContact => _s.reportReviewRowContact;

  // Report categories
  static String get categoryRoadDamage => _s.categoryRoadDamage;
  static String get categoryWater => _s.categoryWater;
  static String get categoryElectricity => _s.categoryElectricity;
  static String get categoryStreetlight => _s.categoryStreetlight;
  static String get categoryDrainage => _s.categoryDrainage;
  static String get categoryWasteManagement => _s.categoryWasteManagement;
  static String get categoryPublicSafety => _s.categoryPublicSafety;
  static String get categoryOther => _s.categoryOther;

  // Appreciation flow — recipient step
  static String get appreciateWhoHeading => _s.appreciateWhoHeading;
  static String get appreciateWhoSubtitle => _s.appreciateWhoSubtitle;
  static String get appreciateRecipientLabel => _s.appreciateRecipientLabel;
  static String get appreciateNoRecipients => _s.appreciateNoRecipients;
  static String get appreciateMlaBadge => _s.appreciateMlaBadge;
  static String get appreciateRelatedWorkLabel => _s.appreciateRelatedWorkLabel;
  static String get appreciateRelatedWorkHint => _s.appreciateRelatedWorkHint;
  static String get appreciateNextMessage => _s.appreciateNextMessage;

  // Appreciation flow — message step
  static String get appreciateMessageHeading => _s.appreciateMessageHeading;
  static String get appreciateMessageSubtitle => _s.appreciateMessageSubtitle;
  static String get appreciateMessageHint => _s.appreciateMessageHint;
  static String get appreciateAddPhotoLabel => _s.appreciateAddPhotoLabel;
  static String get appreciateNextVisibility => _s.appreciateNextVisibility;

  // Appreciation flow — visibility step
  static String get appreciateVisibilityHeading => _s.appreciateVisibilityHeading;
  static String get appreciateVisibilitySubtitle => _s.appreciateVisibilitySubtitle;
  static String get appreciateNextReview => _s.appreciateNextReview;

  // Appreciation flow — review step
  static String get appreciateReviewHeading => _s.appreciateReviewHeading;
  static String get appreciateReviewSubtitle => _s.appreciateReviewSubtitle;
  static String get appreciateCardRecipient => _s.appreciateCardRecipient;
  static String get appreciateCardMessage => _s.appreciateCardMessage;
  static String get appreciateCardVisibility => _s.appreciateCardVisibility;
  static String get appreciateRowStaff => _s.appreciateRowStaff;
  static String get appreciateRowRelatedWork => _s.appreciateRowRelatedWork;
  static String get appreciateRowAnonymous => _s.appreciateRowAnonymous;
  static String get appreciateSubmitBtn => _s.appreciateSubmitBtn;

  // Appreciation flow — success step
  static String get appreciateSuccessMotivation => _s.appreciateSuccessMotivation;
  static String get appreciateSendAnother => _s.appreciateSendAnother;

  // Idea flow — details step
  static String get ideaDetailsHeading => _s.ideaDetailsHeading;
  static String get ideaDetailsSubtitle => _s.ideaDetailsSubtitle;
  static String get ideaTopicLabel => _s.ideaTopicLabel;
  static String get ideaCustomTopicLabel => _s.ideaCustomTopicLabel;
  static String get ideaCustomTopicHint => _s.ideaCustomTopicHint;
  static String get ideaTitleLabel => _s.ideaTitleLabel;
  static String get ideaTitleHint => _s.ideaTitleHint;
  static String get ideaDescLabel => _s.ideaDescLabel;
  static String get ideaDescHint => _s.ideaDescHint;
  static String get ideaNextImpact => _s.ideaNextImpact;

  // Idea flow — impact step
  static String get ideaImpactHeading => _s.ideaImpactHeading;
  static String get ideaImpactSubtitle => _s.ideaImpactSubtitle;
  static String get ideaBenefitsLabel => _s.ideaBenefitsLabel;
  static String get ideaBenefitsHint => _s.ideaBenefitsHint;
  static String get ideaBeneficiariesLabel => _s.ideaBeneficiariesLabel;
  static String get ideaResourcesLabel => _s.ideaResourcesLabel;
  static String get ideaResourcesHint => _s.ideaResourcesHint;
  static String get ideaNextVisibility => _s.ideaNextVisibility;

  // Idea flow — visibility step
  static String get ideaVisibilityHeading => _s.ideaVisibilityHeading;
  static String get ideaVisibilitySubtitle => _s.ideaVisibilitySubtitle;
  static String get ideaDiscussionLabel => _s.ideaDiscussionLabel;
  static String get ideaDiscussionSubtitle => _s.ideaDiscussionSubtitle;
  static String get ideaContactLabel => _s.ideaContactLabel;
  static String get ideaContactSubtitle => _s.ideaContactSubtitle;
  static String get ideaNextReview => _s.ideaNextReview;

  // Idea flow — review step
  static String get ideaReviewHeading => _s.ideaReviewHeading;
  static String get ideaCardDetails => _s.ideaCardDetails;
  static String get ideaCardImpact => _s.ideaCardImpact;
  static String get ideaCardVisibility => _s.ideaCardVisibility;
  static String get ideaRowTopic => _s.ideaRowTopic;
  static String get ideaRowBenefits => _s.ideaRowBenefits;
  static String get ideaRowBeneficiaries => _s.ideaRowBeneficiaries;
  static String get ideaRowResources => _s.ideaRowResources;
  static String get ideaRowDiscussion => _s.ideaRowDiscussion;
  static String get ideaRowContact => _s.ideaRowContact;
  static String get ideaEnabled => _s.ideaEnabled;
  static String get ideaDisabled => _s.ideaDisabled;
  static String get ideaSubmitBtn => _s.ideaSubmitBtn;

  // Improvement flow — suggestion step
  static String get improveHeading => _s.improveHeading;
  static String get improveSubtitle => _s.improveSubtitle;
  static String get improveDeptLabel => _s.improveDeptLabel;
  static String get improveDeptHint => _s.improveDeptHint;
  static String get improveSuggestionLabel => _s.improveSuggestionLabel;
  static String get improveSuggestionHint => _s.improveSuggestionHint;
  static String get improveNextLocation => _s.improveNextLocation;

  // Improvement flow — location step
  static String get improveLocationHeading => _s.improveLocationHeading;
  static String get improveLocationSubtitle => _s.improveLocationSubtitle;
  static String get improveLocationLabel => _s.improveLocationLabel;
  static String get improveLocationHint => _s.improveLocationHint;
  static String get improveLandmarkLabel => _s.improveLandmarkLabel;
  static String get improveLandmarkHint => _s.improveLandmarkHint;
  static String get improveNextReview => _s.improveNextReview;

  // Improvement flow — review step
  static String get improveReviewHeading => _s.improveReviewHeading;
  static String get improveReviewSubtitle => _s.improveReviewSubtitle;
  static String get improveCardDetails => _s.improveCardDetails;
  static String get improveRowDept => _s.improveRowDept;
  static String get improveRowSuggestion => _s.improveRowSuggestion;
  static String get improveRowLocation => _s.improveRowLocation;
  static String get improveRowLandmark => _s.improveRowLandmark;
  static String get improveSubmitBtn => _s.improveSubmitBtn;

  // Improvement flow — success step
  static String get improveSuccessMsg => _s.improveSuccessMsg;
  static String get improveGoHome => _s.improveGoHome;
  static String get improveSubmitAnother => _s.improveSubmitAnother;

  // Shared
  static String get yesLabel => _s.yesLabel;
  static String get noLabel => _s.noLabel;
  static String get maximumReached => _s.maximumReached;
  static String get maximumFilesMsg => _s.maximumFilesMsg;

  // Stepper step names
  static String get stepDetails => _s.stepDetails;
  static String get stepVisibility => _s.stepVisibility;
  static String get stepReview => _s.stepReview;
  static String get stepDone => _s.stepDone;
  static String get stepImpact => _s.stepImpact;
  static String get stepRecipient => _s.stepRecipient;
  static String get stepMessage => _s.stepMessage;
  static String get stepSuggestion => _s.stepSuggestion;
  static String get stepLocation => _s.stepLocation;
}
