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
  static String get mlaActivity => _s.mlaActivity;
  static String get viewAll => _s.viewAll;
  static String get hallOfExcellence => _s.hallOfExcellence;
  static const publicGrievance = 'Public Grievance Hearing';
  static String get viewDetails => _s.viewDetails;

  // Report
  static String get reportProblem => _s.reportProblem;
  static String get describeIssue => _s.describeIssue;
  static const addVoiceNote = 'Add Voice Message';
  static String get addPhotos => _s.addPhotos;
  static String get selectCategory => _s.selectCategory;
  static String get location => _s.location;
  static String get landmark => _s.landmark;
  static const gpsLocation = 'Pin Location (Optional)';
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
  static String get savedEmptyTitle => _s.savedEmptyTitle;
  static String get savedEmptyMsg => _s.savedEmptyMsg;

  // Updates
  static String get updates => _s.updates;
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
}
