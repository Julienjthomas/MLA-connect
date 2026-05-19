import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ml.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ml'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'MLA Connect'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Your voice. Our priority.'**
  String get tagline;

  /// No description provided for @constituency.
  ///
  /// In en, this message translates to:
  /// **'Constituency'**
  String get constituency;

  /// No description provided for @poweredFor.
  ///
  /// In en, this message translates to:
  /// **'Powered for'**
  String get poweredFor;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get welcome;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A platform to connect, contribute and create a better constituency.'**
  String get welcomeSubtitle;

  /// No description provided for @continueWithPhone.
  ///
  /// In en, this message translates to:
  /// **'Continue with Phone Number'**
  String get continueWithPhone;

  /// No description provided for @browsePublicUpdates.
  ///
  /// In en, this message translates to:
  /// **'Browse Public Updates'**
  String get browsePublicUpdates;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language to continue'**
  String get chooseLanguage;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @enterMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number'**
  String get enterMobile;

  /// No description provided for @mobileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll send an OTP to verify your number'**
  String get mobileSubtitle;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @otpSentTo.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to'**
  String get otpSentTo;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP in'**
  String get resendOtp;

  /// No description provided for @resendNow.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendNow;

  /// No description provided for @changeMobile.
  ///
  /// In en, this message translates to:
  /// **'Change Mobile Number'**
  String get changeMobile;

  /// No description provided for @privacyNote.
  ///
  /// In en, this message translates to:
  /// **'We will never share your number with anyone.'**
  String get privacyNote;

  /// No description provided for @selectPanchayat.
  ///
  /// In en, this message translates to:
  /// **'Select Panchayat'**
  String get selectPanchayat;

  /// No description provided for @panchayatHelp.
  ///
  /// In en, this message translates to:
  /// **'This helps us route issues and updates correctly.'**
  String get panchayatHelp;

  /// No description provided for @searchPanchayat.
  ///
  /// In en, this message translates to:
  /// **'Search Panchayat'**
  String get searchPanchayat;

  /// No description provided for @selectWard.
  ///
  /// In en, this message translates to:
  /// **'Select Ward'**
  String get selectWard;

  /// No description provided for @chooseWard.
  ///
  /// In en, this message translates to:
  /// **'Choose your ward in your panchayat'**
  String get chooseWard;

  /// No description provided for @searchWard.
  ///
  /// In en, this message translates to:
  /// **'Search Ward'**
  String get searchWard;

  /// No description provided for @basicProfile.
  ///
  /// In en, this message translates to:
  /// **'Basic Profile'**
  String get basicProfile;

  /// No description provided for @basicProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us a bit about yourself'**
  String get basicProfileSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @emailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email (Optional)'**
  String get emailOptional;

  /// No description provided for @notificationPrefs.
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get notificationPrefs;

  /// No description provided for @notificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose what you would like to receive'**
  String get notificationSubtitle;

  /// No description provided for @issueUpdates.
  ///
  /// In en, this message translates to:
  /// **'Issue Updates'**
  String get issueUpdates;

  /// No description provided for @issueUpdatesDesc.
  ///
  /// In en, this message translates to:
  /// **'Updates on reported issues'**
  String get issueUpdatesDesc;

  /// No description provided for @mlaAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'MLA Announcements'**
  String get mlaAnnouncements;

  /// No description provided for @mlaAnnouncementsDesc.
  ///
  /// In en, this message translates to:
  /// **'Important announcements'**
  String get mlaAnnouncementsDesc;

  /// No description provided for @emergencyAlerts.
  ///
  /// In en, this message translates to:
  /// **'Emergency Alerts'**
  String get emergencyAlerts;

  /// No description provided for @emergencyAlertsDesc.
  ///
  /// In en, this message translates to:
  /// **'Alerts on urgent situations'**
  String get emergencyAlertsDesc;

  /// No description provided for @eventReminders.
  ///
  /// In en, this message translates to:
  /// **'Event Reminders'**
  String get eventReminders;

  /// No description provided for @eventRemindersDesc.
  ///
  /// In en, this message translates to:
  /// **'Upcoming events & programs'**
  String get eventRemindersDesc;

  /// No description provided for @allSet.
  ///
  /// In en, this message translates to:
  /// **'You\'re All Set!'**
  String get allSet;

  /// No description provided for @allSetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to MLA Connect'**
  String get allSetSubtitle;

  /// No description provided for @goToHome.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get goToHome;

  /// No description provided for @whatWouldYouLike.
  ///
  /// In en, this message translates to:
  /// **'What would you like to do?'**
  String get whatWouldYouLike;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions;

  /// No description provided for @quickActionIssue.
  ///
  /// In en, this message translates to:
  /// **'Report Issue'**
  String get quickActionIssue;

  /// No description provided for @quickActionIssueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Roads, water, safety & more'**
  String get quickActionIssueSubtitle;

  /// No description provided for @quickActionIdea.
  ///
  /// In en, this message translates to:
  /// **'Share Idea'**
  String get quickActionIdea;

  /// No description provided for @quickActionIdeaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Suggest ideas for a better future'**
  String get quickActionIdeaSubtitle;

  /// No description provided for @quickActionSuggest.
  ///
  /// In en, this message translates to:
  /// **'Request Help'**
  String get quickActionSuggest;

  /// No description provided for @quickActionSuggestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Seek help or report a problem'**
  String get quickActionSuggestSubtitle;

  /// No description provided for @quickActionAppreciate.
  ///
  /// In en, this message translates to:
  /// **'Appreciate Work'**
  String get quickActionAppreciate;

  /// No description provided for @quickActionAppreciateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Thank people or projects'**
  String get quickActionAppreciateSubtitle;

  /// No description provided for @yourMlaLabel.
  ///
  /// In en, this message translates to:
  /// **'Your MLA'**
  String get yourMlaLabel;

  /// No description provided for @contactOffice.
  ///
  /// In en, this message translates to:
  /// **'Contact Office'**
  String get contactOffice;

  /// No description provided for @messageMla.
  ///
  /// In en, this message translates to:
  /// **'Message MLA'**
  String get messageMla;

  /// No description provided for @meetMla.
  ///
  /// In en, this message translates to:
  /// **'Meet MLA'**
  String get meetMla;

  /// No description provided for @communityBannerHeadline.
  ///
  /// In en, this message translates to:
  /// **'Let\'s build a better tomorrow, together.'**
  String get communityBannerHeadline;

  /// No description provided for @communityBannerSubtext.
  ///
  /// In en, this message translates to:
  /// **'Share issues, ideas and appreciate good work.'**
  String get communityBannerSubtext;

  /// No description provided for @activeIssues.
  ///
  /// In en, this message translates to:
  /// **'Active Issues'**
  String get activeIssues;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @issuesResolvedLabel.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get issuesResolvedLabel;

  /// No description provided for @communityImpactHeader.
  ///
  /// In en, this message translates to:
  /// **'Community Impact'**
  String get communityImpactHeader;

  /// No description provided for @communityImpactTagline.
  ///
  /// In en, this message translates to:
  /// **'Together we are creating real change'**
  String get communityImpactTagline;

  /// No description provided for @issuesResolvedStat.
  ///
  /// In en, this message translates to:
  /// **'Issues Resolved'**
  String get issuesResolvedStat;

  /// No description provided for @ideasImplementedStat.
  ///
  /// In en, this message translates to:
  /// **'Ideas Implemented'**
  String get ideasImplementedStat;

  /// No description provided for @appreciationsSharedStat.
  ///
  /// In en, this message translates to:
  /// **'Appreciations Shared'**
  String get appreciationsSharedStat;

  /// No description provided for @raiseNewIssue.
  ///
  /// In en, this message translates to:
  /// **'Raise New Issue'**
  String get raiseNewIssue;

  /// No description provided for @statusNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get statusNew;

  /// No description provided for @mlaActivity.
  ///
  /// In en, this message translates to:
  /// **'MLA Activity'**
  String get mlaActivity;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @hallOfExcellence.
  ///
  /// In en, this message translates to:
  /// **'HALL OF EXCELLENCE'**
  String get hallOfExcellence;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @reportProblem.
  ///
  /// In en, this message translates to:
  /// **'Report a Problem'**
  String get reportProblem;

  /// No description provided for @describeIssue.
  ///
  /// In en, this message translates to:
  /// **'Describe the Problem'**
  String get describeIssue;

  /// No description provided for @addPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add Photos / Videos (Optional)'**
  String get addPhotos;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get selectCategory;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @landmark.
  ///
  /// In en, this message translates to:
  /// **'Landmark / Area (Optional)'**
  String get landmark;

  /// No description provided for @contactNumber.
  ///
  /// In en, this message translates to:
  /// **'Contact Number'**
  String get contactNumber;

  /// No description provided for @submitReport.
  ///
  /// In en, this message translates to:
  /// **'Submit Report'**
  String get submitReport;

  /// No description provided for @reportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your Report has been\nSubmitted Successfully!'**
  String get reportSuccess;

  /// No description provided for @reportSuccessMsg.
  ///
  /// In en, this message translates to:
  /// **'We received your report and our team will take action soon.'**
  String get reportSuccessMsg;

  /// No description provided for @trackInActivity.
  ///
  /// In en, this message translates to:
  /// **'Track in My Activity'**
  String get trackInActivity;

  /// No description provided for @reportAnother.
  ///
  /// In en, this message translates to:
  /// **'Report Another Issue'**
  String get reportAnother;

  /// No description provided for @appreciateTitle.
  ///
  /// In en, this message translates to:
  /// **'Submit Appreciation'**
  String get appreciateTitle;

  /// No description provided for @recipientCategory.
  ///
  /// In en, this message translates to:
  /// **'Recipient Category'**
  String get recipientCategory;

  /// No description provided for @staffName.
  ///
  /// In en, this message translates to:
  /// **'Staff Name / ID (Optional)'**
  String get staffName;

  /// No description provided for @relatedWork.
  ///
  /// In en, this message translates to:
  /// **'Related Work / Project (Optional)'**
  String get relatedWork;

  /// No description provided for @yourAppreciation.
  ///
  /// In en, this message translates to:
  /// **'Your Appreciation'**
  String get yourAppreciation;

  /// No description provided for @appreciationMsg.
  ///
  /// In en, this message translates to:
  /// **'Write your appreciation...'**
  String get appreciationMsg;

  /// No description provided for @appreciationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Thank You!\nYour appreciation has been\nshared successfully.'**
  String get appreciationSuccess;

  /// No description provided for @shareIdea.
  ///
  /// In en, this message translates to:
  /// **'Share Idea'**
  String get shareIdea;

  /// No description provided for @ideaTitle.
  ///
  /// In en, this message translates to:
  /// **'Idea Title'**
  String get ideaTitle;

  /// No description provided for @ideaDescription.
  ///
  /// In en, this message translates to:
  /// **'Describe your idea in detail'**
  String get ideaDescription;

  /// No description provided for @keyBenefits.
  ///
  /// In en, this message translates to:
  /// **'Key Benefits & Expected Impact'**
  String get keyBenefits;

  /// No description provided for @whoBenefits.
  ///
  /// In en, this message translates to:
  /// **'Who will benefit from this idea?'**
  String get whoBenefits;

  /// No description provided for @estimatedResources.
  ///
  /// In en, this message translates to:
  /// **'Estimated Resources (Optional)'**
  String get estimatedResources;

  /// No description provided for @ideaSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your Idea has been\nSubmitted Successfully!'**
  String get ideaSuccess;

  /// No description provided for @suggestImprovement.
  ///
  /// In en, this message translates to:
  /// **'Suggest Improvement'**
  String get suggestImprovement;

  /// No description provided for @suggestionDetails.
  ///
  /// In en, this message translates to:
  /// **'Suggestion Details'**
  String get suggestionDetails;

  /// No description provided for @targetDepartment.
  ///
  /// In en, this message translates to:
  /// **'Target Department'**
  String get targetDepartment;

  /// No description provided for @improvementSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your Suggestion has been\nSubmitted Successfully!'**
  String get improvementSuccess;

  /// No description provided for @myActivity.
  ///
  /// In en, this message translates to:
  /// **'My Activity'**
  String get myActivity;

  /// No description provided for @trackContributions.
  ///
  /// In en, this message translates to:
  /// **'Track all your contributions and updates'**
  String get trackContributions;

  /// No description provided for @updates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get updates;

  /// No description provided for @stayUpdated.
  ///
  /// In en, this message translates to:
  /// **'Stay updated with the latest activities'**
  String get stayUpdated;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @contactMlaOffice.
  ///
  /// In en, this message translates to:
  /// **'Contact MLA Office'**
  String get contactMlaOffice;

  /// No description provided for @chatWithYourMla.
  ///
  /// In en, this message translates to:
  /// **'Chat with MLA'**
  String get chatWithYourMla;

  /// No description provided for @chatWithYourMlaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Message your MLA office directly'**
  String get chatWithYourMlaSubtitle;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About MLA Connect'**
  String get aboutApp;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get error;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternet;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get required;

  /// No description provided for @statusSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get statusSubmitted;

  /// No description provided for @statusReview.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get statusReview;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get statusInProgress;

  /// No description provided for @statusResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get statusResolved;

  /// No description provided for @statusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get statusClosed;

  /// No description provided for @categoryRoad.
  ///
  /// In en, this message translates to:
  /// **'Road & Infrastructure'**
  String get categoryRoad;

  /// No description provided for @categoryWater.
  ///
  /// In en, this message translates to:
  /// **'Water Supply'**
  String get categoryWater;

  /// No description provided for @categorySanitation.
  ///
  /// In en, this message translates to:
  /// **'Sanitation'**
  String get categorySanitation;

  /// No description provided for @categoryElectricity.
  ///
  /// In en, this message translates to:
  /// **'Electricity'**
  String get categoryElectricity;

  /// No description provided for @categoryHealthcare.
  ///
  /// In en, this message translates to:
  /// **'Healthcare'**
  String get categoryHealthcare;

  /// No description provided for @categoryEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get categoryEducation;

  /// No description provided for @categoryEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get categoryEnvironment;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @discardChanges.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get discardChanges;

  /// No description provided for @discardConfirm.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved data. Going back will discard it.'**
  String get discardConfirm;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @keepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep Editing'**
  String get keepEditing;

  /// No description provided for @noReports.
  ///
  /// In en, this message translates to:
  /// **'No Reports Yet'**
  String get noReports;

  /// No description provided for @noReportsMsg.
  ///
  /// In en, this message translates to:
  /// **'Your reported issues will appear here.'**
  String get noReportsMsg;

  /// No description provided for @noIdeas.
  ///
  /// In en, this message translates to:
  /// **'No Ideas Yet'**
  String get noIdeas;

  /// No description provided for @noIdeasMsg.
  ///
  /// In en, this message translates to:
  /// **'Ideas you share will appear here.'**
  String get noIdeasMsg;

  /// No description provided for @noAppreciations.
  ///
  /// In en, this message translates to:
  /// **'No Appreciations Yet'**
  String get noAppreciations;

  /// No description provided for @noAppreciationsMsg.
  ///
  /// In en, this message translates to:
  /// **'Appreciations you\'ve sent will appear here.'**
  String get noAppreciationsMsg;

  /// No description provided for @noUpdates.
  ///
  /// In en, this message translates to:
  /// **'No Updates'**
  String get noUpdates;

  /// No description provided for @noUpdatesMsg.
  ///
  /// In en, this message translates to:
  /// **'No updates for this category yet.'**
  String get noUpdatesMsg;

  /// No description provided for @savedEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved yet'**
  String get savedEmptyTitle;

  /// No description provided for @savedEmptyMsg.
  ///
  /// In en, this message translates to:
  /// **'Save Updates posts and publicly shared ideas here to find them later.'**
  String get savedEmptyMsg;

  /// No description provided for @reportNotFound.
  ///
  /// In en, this message translates to:
  /// **'Report not found'**
  String get reportNotFound;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @statusTimeline.
  ///
  /// In en, this message translates to:
  /// **'Status Timeline'**
  String get statusTimeline;

  /// No description provided for @featureReportLabel.
  ///
  /// In en, this message translates to:
  /// **'Report Problem'**
  String get featureReportLabel;

  /// No description provided for @featureReportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Roads, water, waste, safety & public issues'**
  String get featureReportSubtitle;

  /// No description provided for @featureIdeaLabel.
  ///
  /// In en, this message translates to:
  /// **'Share Idea'**
  String get featureIdeaLabel;

  /// No description provided for @featureIdeaSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Big ideas for the future of our constituency'**
  String get featureIdeaSubtitle;

  /// No description provided for @featureImproveLabel.
  ///
  /// In en, this message translates to:
  /// **'Suggest Improvement'**
  String get featureImproveLabel;

  /// No description provided for @featureImproveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Practical improvements for a better future'**
  String get featureImproveSubtitle;

  /// No description provided for @featureAppreciateLabel.
  ///
  /// In en, this message translates to:
  /// **'Appreciate'**
  String get featureAppreciateLabel;

  /// No description provided for @featureAppreciateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recognize good work, staff or projects'**
  String get featureAppreciateSubtitle;

  /// No description provided for @communityImpactTitle.
  ///
  /// In en, this message translates to:
  /// **'Community Impact'**
  String get communityImpactTitle;

  /// No description provided for @communityImpactSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This month in your constituency'**
  String get communityImpactSubtitle;

  /// No description provided for @communityImpactReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get communityImpactReports;

  /// No description provided for @communityImpactIdeas.
  ///
  /// In en, this message translates to:
  /// **'Ideas'**
  String get communityImpactIdeas;

  /// No description provided for @communityImpactThanks.
  ///
  /// In en, this message translates to:
  /// **'Thanks'**
  String get communityImpactThanks;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @helpFaq.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get helpFaq;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirm;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @addMore.
  ///
  /// In en, this message translates to:
  /// **'Add More'**
  String get addMore;

  /// No description provided for @callOffice.
  ///
  /// In en, this message translates to:
  /// **'Call Office'**
  String get callOffice;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @contactDetailsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Contact details not yet available.'**
  String get contactDetailsUnavailable;

  /// No description provided for @contactDetailsUnavailableMsg.
  ///
  /// In en, this message translates to:
  /// **'The MLA office has not published contact channels for this constituency.'**
  String get contactDetailsUnavailableMsg;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @aboutMla.
  ///
  /// In en, this message translates to:
  /// **'About MLA'**
  String get aboutMla;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @mlaDataUnavailable.
  ///
  /// In en, this message translates to:
  /// **'MLA data unavailable'**
  String get mlaDataUnavailable;

  /// No description provided for @mlaOfficeDetailsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'MLA office details unavailable.'**
  String get mlaOfficeDetailsUnavailable;

  /// No description provided for @ideaSuccessMsg.
  ///
  /// In en, this message translates to:
  /// **'Thank you for contributing to a better constituency. Your idea will be reviewed by our team and you will be notified.'**
  String get ideaSuccessMsg;

  /// No description provided for @ideaSuccessPublicVisible.
  ///
  /// In en, this message translates to:
  /// **'Your public ideas will be visible to the community.'**
  String get ideaSuccessPublicVisible;

  /// No description provided for @ideaSuccessPublicUpvote.
  ///
  /// In en, this message translates to:
  /// **'People can upvote and suggest improvements.'**
  String get ideaSuccessPublicUpvote;

  /// No description provided for @ideaSuccessPrivateSent.
  ///
  /// In en, this message translates to:
  /// **'Your idea has been sent privately to the MLA office.'**
  String get ideaSuccessPrivateSent;

  /// No description provided for @ideaSuccessPrivateOnly.
  ///
  /// In en, this message translates to:
  /// **'Only the MLA office can view this idea.'**
  String get ideaSuccessPrivateOnly;

  /// No description provided for @ideaSuccessTeamReview.
  ///
  /// In en, this message translates to:
  /// **'Our team will review and may contact you for more details.'**
  String get ideaSuccessTeamReview;

  /// No description provided for @goToMyActivity.
  ///
  /// In en, this message translates to:
  /// **'Go to My Activity'**
  String get goToMyActivity;

  /// No description provided for @submitAnotherIdea.
  ///
  /// In en, this message translates to:
  /// **'Submit Another Idea'**
  String get submitAnotherIdea;

  /// No description provided for @yourReferenceId.
  ///
  /// In en, this message translates to:
  /// **'Your Reference ID'**
  String get yourReferenceId;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @referenceIdCopied.
  ///
  /// In en, this message translates to:
  /// **'Reference ID copied to clipboard'**
  String get referenceIdCopied;

  /// No description provided for @unableToOpen.
  ///
  /// In en, this message translates to:
  /// **'Unable to open'**
  String get unableToOpen;

  /// No description provided for @publicGrievanceHearing.
  ///
  /// In en, this message translates to:
  /// **'Public Grievance Hearing'**
  String get publicGrievanceHearing;

  /// No description provided for @addVoiceMessage.
  ///
  /// In en, this message translates to:
  /// **'Add Voice Message'**
  String get addVoiceMessage;

  /// No description provided for @pinLocationOptional.
  ///
  /// In en, this message translates to:
  /// **'Pin Location (Optional)'**
  String get pinLocationOptional;

  /// No description provided for @privacyLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated: May 2026'**
  String get privacyLastUpdated;

  /// No description provided for @privacyIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'1. Introduction'**
  String get privacyIntroTitle;

  /// No description provided for @privacyIntroBody.
  ///
  /// In en, this message translates to:
  /// **'MLA Connect (\"we\", \"us\") is a civic engagement platform. This Privacy Policy describes how we collect, use, and protect your information when you use this app.'**
  String get privacyIntroBody;

  /// No description provided for @privacyCollectTitle.
  ///
  /// In en, this message translates to:
  /// **'2. Information we collect'**
  String get privacyCollectTitle;

  /// No description provided for @privacyCollectBody.
  ///
  /// In en, this message translates to:
  /// **'Account information (phone number, name, photo, constituency), submission content (text, images, voice messages, location), and basic device telemetry needed to operate the service.'**
  String get privacyCollectBody;

  /// No description provided for @privacyUseTitle.
  ///
  /// In en, this message translates to:
  /// **'3. How we use your information'**
  String get privacyUseTitle;

  /// No description provided for @privacyUseBody.
  ///
  /// In en, this message translates to:
  /// **'To route your submissions to the appropriate MLA office and departments, to provide status updates, to display public submissions to the community where you have chosen public visibility, and to improve the service.'**
  String get privacyUseBody;

  /// No description provided for @privacySharingTitle.
  ///
  /// In en, this message translates to:
  /// **'4. Sharing'**
  String get privacySharingTitle;

  /// No description provided for @privacySharingBody.
  ///
  /// In en, this message translates to:
  /// **'We share submission content with the MLA office and the relevant department. Public submissions are visible to other citizens within your constituency. We do not sell your personal data to third parties.'**
  String get privacySharingBody;

  /// No description provided for @privacyStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'5. Storage and security'**
  String get privacyStorageTitle;

  /// No description provided for @privacyStorageBody.
  ///
  /// In en, this message translates to:
  /// **'Data is stored on secure infrastructure with industry-standard access controls. Voice and image attachments are stored in private buckets and accessed via signed URLs.'**
  String get privacyStorageBody;

  /// No description provided for @privacyChoicesTitle.
  ///
  /// In en, this message translates to:
  /// **'6. Your choices'**
  String get privacyChoicesTitle;

  /// No description provided for @privacyChoicesBody.
  ///
  /// In en, this message translates to:
  /// **'You can choose the visibility of each submission (public, MLA office only, anonymous). You can request deletion of your account and associated data by contacting the MLA office through the app.'**
  String get privacyChoicesBody;

  /// No description provided for @privacyContactTitle.
  ///
  /// In en, this message translates to:
  /// **'7. Contact'**
  String get privacyContactTitle;

  /// No description provided for @privacyContactBody.
  ///
  /// In en, this message translates to:
  /// **'For privacy questions, use the Contact MLA Office screen in this app.'**
  String get privacyContactBody;

  /// No description provided for @helpFaqQ1.
  ///
  /// In en, this message translates to:
  /// **'What is MLA Connect?'**
  String get helpFaqQ1;

  /// No description provided for @helpFaqA1.
  ///
  /// In en, this message translates to:
  /// **'MLA Connect is your direct line to your MLA and their office. Report issues, share ideas, suggest improvements, and appreciate good work in your constituency — all in one app.'**
  String get helpFaqA1;

  /// No description provided for @helpFaqQ2.
  ///
  /// In en, this message translates to:
  /// **'Who can see my report?'**
  String get helpFaqQ2;

  /// No description provided for @helpFaqA2.
  ///
  /// In en, this message translates to:
  /// **'Reports are shared with the MLA office and the relevant department. You choose the visibility — public (visible to the community), MLA office only, or anonymous.'**
  String get helpFaqA2;

  /// No description provided for @helpFaqQ3.
  ///
  /// In en, this message translates to:
  /// **'How do I track a submission?'**
  String get helpFaqQ3;

  /// No description provided for @helpFaqA3.
  ///
  /// In en, this message translates to:
  /// **'Open the Activity tab in the bottom navigation to see all your submissions and their current status.'**
  String get helpFaqA3;

  /// No description provided for @helpFaqQ4.
  ///
  /// In en, this message translates to:
  /// **'Will I get notified about updates?'**
  String get helpFaqQ4;

  /// No description provided for @helpFaqA4.
  ///
  /// In en, this message translates to:
  /// **'Yes — you will receive in-app notifications when your submission status changes or the MLA office responds.'**
  String get helpFaqA4;

  /// No description provided for @helpFaqQ5.
  ///
  /// In en, this message translates to:
  /// **'Can I edit a submission after sending it?'**
  String get helpFaqQ5;

  /// No description provided for @helpFaqA5.
  ///
  /// In en, this message translates to:
  /// **'Submitted reports cannot be edited, but you can add comments or attach further information from the submission detail screen.'**
  String get helpFaqA5;

  /// No description provided for @helpFaqQ6.
  ///
  /// In en, this message translates to:
  /// **'How do I change my constituency?'**
  String get helpFaqQ6;

  /// No description provided for @helpFaqA6.
  ///
  /// In en, this message translates to:
  /// **'Go to Profile → Edit Profile, or sign out and complete the onboarding flow again with your new constituency.'**
  String get helpFaqA6;

  /// No description provided for @helpFaqQ7.
  ///
  /// In en, this message translates to:
  /// **'Is my personal data private?'**
  String get helpFaqQ7;

  /// No description provided for @helpFaqA7.
  ///
  /// In en, this message translates to:
  /// **'Yes. Your data is stored securely and shared only with the MLA office as required to act on your submission. See the Privacy Policy for full details.'**
  String get helpFaqA7;

  /// No description provided for @statusAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get statusAssigned;

  /// No description provided for @noImprovements.
  ///
  /// In en, this message translates to:
  /// **'No Improvements Yet'**
  String get noImprovements;

  /// No description provided for @noImprovementsMsg.
  ///
  /// In en, this message translates to:
  /// **'Suggestions you share will appear here.'**
  String get noImprovementsMsg;

  /// No description provided for @activityTabReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get activityTabReports;

  /// No description provided for @activityTabIdeas.
  ///
  /// In en, this message translates to:
  /// **'Ideas'**
  String get activityTabIdeas;

  /// No description provided for @activityTabImprovements.
  ///
  /// In en, this message translates to:
  /// **'Improvements'**
  String get activityTabImprovements;

  /// No description provided for @activityTabAppreciations.
  ///
  /// In en, this message translates to:
  /// **'Appreciations'**
  String get activityTabAppreciations;

  /// No description provided for @activityTabSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get activityTabSaved;

  /// No description provided for @activityFabReport.
  ///
  /// In en, this message translates to:
  /// **'Report a Problem'**
  String get activityFabReport;

  /// No description provided for @activityFabIdea.
  ///
  /// In en, this message translates to:
  /// **'Share an Idea'**
  String get activityFabIdea;

  /// No description provided for @activityFabImprovement.
  ///
  /// In en, this message translates to:
  /// **'Suggest Improvement'**
  String get activityFabImprovement;

  /// No description provided for @activityFabAppreciation.
  ///
  /// In en, this message translates to:
  /// **'Send Appreciation'**
  String get activityFabAppreciation;

  /// No description provided for @activityGreatGoing.
  ///
  /// In en, this message translates to:
  /// **'Great going!'**
  String get activityGreatGoing;

  /// No description provided for @activityGreatGoingNamed.
  ///
  /// In en, this message translates to:
  /// **'Great going, {name}!'**
  String activityGreatGoingNamed(String name);

  /// No description provided for @activityContributionsSoFar.
  ///
  /// In en, this message translates to:
  /// **'{count} contributions so far'**
  String activityContributionsSoFar(int count);

  /// No description provided for @activityCommunityTagline.
  ///
  /// In en, this message translates to:
  /// **'You\'re helping build a better community.'**
  String get activityCommunityTagline;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get filterActive;

  /// No description provided for @activityNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get activityNoMatches;

  /// No description provided for @activityNoReportsWithStatus.
  ///
  /// In en, this message translates to:
  /// **'No reports with this status.'**
  String get activityNoReportsWithStatus;

  /// No description provided for @activityEmptyHeadline.
  ///
  /// In en, this message translates to:
  /// **'Start contributing to your community'**
  String get activityEmptyHeadline;

  /// No description provided for @activityEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Report issues, share ideas and track updates from your constituency.'**
  String get activityEmptyMessage;

  /// No description provided for @activityIdWard.
  ///
  /// In en, this message translates to:
  /// **'ID: {id}  •  {ward}'**
  String activityIdWard(String id, String ward);

  /// No description provided for @reportDetail.
  ///
  /// In en, this message translates to:
  /// **'Report Detail'**
  String get reportDetail;

  /// No description provided for @visibilityPublic.
  ///
  /// In en, this message translates to:
  /// **'Public Wall'**
  String get visibilityPublic;

  /// No description provided for @visibilityMlaOnly.
  ///
  /// In en, this message translates to:
  /// **'MLA Office Only'**
  String get visibilityMlaOnly;

  /// No description provided for @visibilityAnonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get visibilityAnonymous;

  /// No description provided for @visibilityPublicDesc.
  ///
  /// In en, this message translates to:
  /// **'Visible to everyone on the platform'**
  String get visibilityPublicDesc;

  /// No description provided for @visibilityMlaOnlyDesc.
  ///
  /// In en, this message translates to:
  /// **'Only MLA office can view this'**
  String get visibilityMlaOnlyDesc;

  /// No description provided for @visibilityAnonymousDesc.
  ///
  /// In en, this message translates to:
  /// **'Your name will be hidden'**
  String get visibilityAnonymousDesc;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get navActivity;

  /// No description provided for @navUpdates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get navUpdates;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @reportDescribeProblem.
  ///
  /// In en, this message translates to:
  /// **'Describe the Problem'**
  String get reportDescribeProblem;

  /// No description provided for @reportDescribeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please provide details about the issue'**
  String get reportDescribeSubtitle;

  /// No description provided for @reportCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category *'**
  String get reportCategoryLabel;

  /// No description provided for @reportCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the problem category'**
  String get reportCategoryHint;

  /// No description provided for @reportDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Problem Description *'**
  String get reportDescriptionLabel;

  /// No description provided for @reportDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the problem in detail...'**
  String get reportDescriptionHint;

  /// No description provided for @reportDetailsLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the exact location of the problem'**
  String get reportDetailsLocationHint;

  /// No description provided for @reportNextReview.
  ///
  /// In en, this message translates to:
  /// **'Next: Review →'**
  String get reportNextReview;

  /// No description provided for @reportLocationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us find the exact location of the issue'**
  String get reportLocationSubtitle;

  /// No description provided for @reportPanchayatLabel.
  ///
  /// In en, this message translates to:
  /// **'Panchayat'**
  String get reportPanchayatLabel;

  /// No description provided for @reportWardLabel.
  ///
  /// In en, this message translates to:
  /// **'Ward *'**
  String get reportWardLabel;

  /// No description provided for @reportLandmarkAreaLabel.
  ///
  /// In en, this message translates to:
  /// **'Landmark / Area (Optional)'**
  String get reportLandmarkAreaLabel;

  /// No description provided for @reportLocationDescLabel.
  ///
  /// In en, this message translates to:
  /// **'Location Description *'**
  String get reportLocationDescLabel;

  /// No description provided for @reportLocationDescHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the location'**
  String get reportLocationDescHint;

  /// No description provided for @reportGpsNote.
  ///
  /// In en, this message translates to:
  /// **'Tap the location icon to use GPS'**
  String get reportGpsNote;

  /// No description provided for @reportMapPin.
  ///
  /// In en, this message translates to:
  /// **'Tap to pin on map'**
  String get reportMapPin;

  /// No description provided for @reportContactLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact Number (Optional)'**
  String get reportContactLabel;

  /// No description provided for @reportVisibilitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose who can see this report'**
  String get reportVisibilitySubtitle;

  /// No description provided for @reportVisibilityFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Visibility Option *'**
  String get reportVisibilityFieldLabel;

  /// No description provided for @reportReviewHeading.
  ///
  /// In en, this message translates to:
  /// **'Review Report'**
  String get reportReviewHeading;

  /// No description provided for @reportReviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please review your report before submitting'**
  String get reportReviewSubtitle;

  /// No description provided for @reportReviewSectionDetails.
  ///
  /// In en, this message translates to:
  /// **'Problem Details'**
  String get reportReviewSectionDetails;

  /// No description provided for @reportReviewRowCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get reportReviewRowCategory;

  /// No description provided for @reportReviewRowTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get reportReviewRowTitle;

  /// No description provided for @reportReviewRowDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get reportReviewRowDescription;

  /// No description provided for @reportReviewRowVisibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get reportReviewRowVisibility;

  /// No description provided for @reportReviewRowLandmark.
  ///
  /// In en, this message translates to:
  /// **'Landmark'**
  String get reportReviewRowLandmark;

  /// No description provided for @reportReviewRowContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get reportReviewRowContact;

  /// No description provided for @categoryRoadDamage.
  ///
  /// In en, this message translates to:
  /// **'Road Damage'**
  String get categoryRoadDamage;

  /// No description provided for @categoryStreetlight.
  ///
  /// In en, this message translates to:
  /// **'Street Light'**
  String get categoryStreetlight;

  /// No description provided for @categoryDrainage.
  ///
  /// In en, this message translates to:
  /// **'Drainage'**
  String get categoryDrainage;

  /// No description provided for @categoryWasteManagement.
  ///
  /// In en, this message translates to:
  /// **'Waste Management'**
  String get categoryWasteManagement;

  /// No description provided for @categoryPublicSafety.
  ///
  /// In en, this message translates to:
  /// **'Public Safety'**
  String get categoryPublicSafety;

  /// No description provided for @appreciateWhoHeading.
  ///
  /// In en, this message translates to:
  /// **'Who are you appreciating?'**
  String get appreciateWhoHeading;

  /// No description provided for @appreciateWhoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your MLA or a direct staff member.'**
  String get appreciateWhoSubtitle;

  /// No description provided for @appreciateRecipientLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipient *'**
  String get appreciateRecipientLabel;

  /// No description provided for @appreciateNoRecipients.
  ///
  /// In en, this message translates to:
  /// **'No recipients available yet.'**
  String get appreciateNoRecipients;

  /// No description provided for @appreciateMlaBadge.
  ///
  /// In en, this message translates to:
  /// **'MLA'**
  String get appreciateMlaBadge;

  /// No description provided for @appreciateRelatedWorkLabel.
  ///
  /// In en, this message translates to:
  /// **'Related Work / Project (Optional)'**
  String get appreciateRelatedWorkLabel;

  /// No description provided for @appreciateRelatedWorkHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Road repair at Kuttikattoor'**
  String get appreciateRelatedWorkHint;

  /// No description provided for @appreciateNextMessage.
  ///
  /// In en, this message translates to:
  /// **'Next: Your Message →'**
  String get appreciateNextMessage;

  /// No description provided for @appreciateMessageHeading.
  ///
  /// In en, this message translates to:
  /// **'Your Appreciation'**
  String get appreciateMessageHeading;

  /// No description provided for @appreciateMessageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Write your appreciation message'**
  String get appreciateMessageSubtitle;

  /// No description provided for @appreciateMessageHint.
  ///
  /// In en, this message translates to:
  /// **'I appreciate the quick action taken by the team...'**
  String get appreciateMessageHint;

  /// No description provided for @appreciateAddPhotoLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Photo / Video (Optional)'**
  String get appreciateAddPhotoLabel;

  /// No description provided for @appreciateNextVisibility.
  ///
  /// In en, this message translates to:
  /// **'Next: Visibility →'**
  String get appreciateNextVisibility;

  /// No description provided for @appreciateVisibilityHeading.
  ///
  /// In en, this message translates to:
  /// **'Visibility Option'**
  String get appreciateVisibilityHeading;

  /// No description provided for @appreciateVisibilitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to share'**
  String get appreciateVisibilitySubtitle;

  /// No description provided for @appreciateNextReview.
  ///
  /// In en, this message translates to:
  /// **'Next: Review →'**
  String get appreciateNextReview;

  /// No description provided for @appreciateReviewHeading.
  ///
  /// In en, this message translates to:
  /// **'Review your appreciation'**
  String get appreciateReviewHeading;

  /// No description provided for @appreciateReviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please review before submitting'**
  String get appreciateReviewSubtitle;

  /// No description provided for @appreciateCardRecipient.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get appreciateCardRecipient;

  /// No description provided for @appreciateCardMessage.
  ///
  /// In en, this message translates to:
  /// **'Your Message'**
  String get appreciateCardMessage;

  /// No description provided for @appreciateCardVisibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get appreciateCardVisibility;

  /// No description provided for @appreciateRowStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get appreciateRowStaff;

  /// No description provided for @appreciateRowRelatedWork.
  ///
  /// In en, this message translates to:
  /// **'Related Work'**
  String get appreciateRowRelatedWork;

  /// No description provided for @appreciateRowAnonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get appreciateRowAnonymous;

  /// No description provided for @appreciateSubmitBtn.
  ///
  /// In en, this message translates to:
  /// **'Submit Appreciation'**
  String get appreciateSubmitBtn;

  /// No description provided for @appreciateSuccessMotivation.
  ///
  /// In en, this message translates to:
  /// **'Your kind words will motivate them to do even better.'**
  String get appreciateSuccessMotivation;

  /// No description provided for @appreciateSendAnother.
  ///
  /// In en, this message translates to:
  /// **'Send Another Appreciation'**
  String get appreciateSendAnother;

  /// No description provided for @ideaDetailsHeading.
  ///
  /// In en, this message translates to:
  /// **'Idea Details'**
  String get ideaDetailsHeading;

  /// No description provided for @ideaDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your idea'**
  String get ideaDetailsSubtitle;

  /// No description provided for @ideaTopicLabel.
  ///
  /// In en, this message translates to:
  /// **'What is your idea about? (Topic) *'**
  String get ideaTopicLabel;

  /// No description provided for @ideaCustomTopicLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom Topic *'**
  String get ideaCustomTopicLabel;

  /// No description provided for @ideaCustomTopicHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your topic'**
  String get ideaCustomTopicHint;

  /// No description provided for @ideaTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Idea Title *'**
  String get ideaTitleLabel;

  /// No description provided for @ideaTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Smart drainage system for your area'**
  String get ideaTitleHint;

  /// No description provided for @ideaDescLabel.
  ///
  /// In en, this message translates to:
  /// **'Describe your idea in detail'**
  String get ideaDescLabel;

  /// No description provided for @ideaDescHint.
  ///
  /// In en, this message translates to:
  /// **'My idea is to build a smart drainage system...'**
  String get ideaDescHint;

  /// No description provided for @ideaNextImpact.
  ///
  /// In en, this message translates to:
  /// **'Next: Impact & Benefits →'**
  String get ideaNextImpact;

  /// No description provided for @ideaImpactHeading.
  ///
  /// In en, this message translates to:
  /// **'Key Benefits & Expected Impact'**
  String get ideaImpactHeading;

  /// No description provided for @ideaImpactSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us understand the potential impact'**
  String get ideaImpactSubtitle;

  /// No description provided for @ideaBenefitsLabel.
  ///
  /// In en, this message translates to:
  /// **'List 2–3 major advantages for the constituency *'**
  String get ideaBenefitsLabel;

  /// No description provided for @ideaBenefitsHint.
  ///
  /// In en, this message translates to:
  /// **'• Reduces flooding in low-lying areas\n• Protects public health...'**
  String get ideaBenefitsHint;

  /// No description provided for @ideaBeneficiariesLabel.
  ///
  /// In en, this message translates to:
  /// **'Who will benefit from this idea? *'**
  String get ideaBeneficiariesLabel;

  /// No description provided for @ideaResourcesLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated Resources (Optional)'**
  String get ideaResourcesLabel;

  /// No description provided for @ideaResourcesHint.
  ///
  /// In en, this message translates to:
  /// **'Select Range'**
  String get ideaResourcesHint;

  /// No description provided for @ideaNextVisibility.
  ///
  /// In en, this message translates to:
  /// **'Next: Visibility →'**
  String get ideaNextVisibility;

  /// No description provided for @ideaVisibilityHeading.
  ///
  /// In en, this message translates to:
  /// **'Visibility & Collaboration'**
  String get ideaVisibilityHeading;

  /// No description provided for @ideaVisibilitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to share your idea'**
  String get ideaVisibilitySubtitle;

  /// No description provided for @ideaVisibilityFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Visibility Option *'**
  String get ideaVisibilityFieldLabel;

  /// No description provided for @ideaDiscussionLabel.
  ///
  /// In en, this message translates to:
  /// **'Allow Community Discussion'**
  String get ideaDiscussionLabel;

  /// No description provided for @ideaDiscussionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'People can comment and suggest improvements'**
  String get ideaDiscussionSubtitle;

  /// No description provided for @ideaContactLabel.
  ///
  /// In en, this message translates to:
  /// **'Allow MLA Office to Contact Me'**
  String get ideaContactLabel;

  /// No description provided for @ideaContactSubtitle.
  ///
  /// In en, this message translates to:
  /// **'MLA office can reach out for more details'**
  String get ideaContactSubtitle;

  /// No description provided for @ideaNextReview.
  ///
  /// In en, this message translates to:
  /// **'Next: Review Idea →'**
  String get ideaNextReview;

  /// No description provided for @ideaReviewHeading.
  ///
  /// In en, this message translates to:
  /// **'Please review your idea before submitting'**
  String get ideaReviewHeading;

  /// No description provided for @ideaCardDetails.
  ///
  /// In en, this message translates to:
  /// **'Idea Details'**
  String get ideaCardDetails;

  /// No description provided for @ideaCardImpact.
  ///
  /// In en, this message translates to:
  /// **'Impact & Benefits'**
  String get ideaCardImpact;

  /// No description provided for @ideaCardVisibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get ideaCardVisibility;

  /// No description provided for @ideaRowTopic.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get ideaRowTopic;

  /// No description provided for @ideaRowBenefits.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get ideaRowBenefits;

  /// No description provided for @ideaRowBeneficiaries.
  ///
  /// In en, this message translates to:
  /// **'Beneficiaries'**
  String get ideaRowBeneficiaries;

  /// No description provided for @ideaRowResources.
  ///
  /// In en, this message translates to:
  /// **'Resources'**
  String get ideaRowResources;

  /// No description provided for @ideaRowDiscussion.
  ///
  /// In en, this message translates to:
  /// **'Community Discussion'**
  String get ideaRowDiscussion;

  /// No description provided for @ideaRowContact.
  ///
  /// In en, this message translates to:
  /// **'MLA Contact'**
  String get ideaRowContact;

  /// No description provided for @ideaEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get ideaEnabled;

  /// No description provided for @ideaDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get ideaDisabled;

  /// No description provided for @ideaSubmitBtn.
  ///
  /// In en, this message translates to:
  /// **'Submit Idea 🚀'**
  String get ideaSubmitBtn;

  /// No description provided for @improveHeading.
  ///
  /// In en, this message translates to:
  /// **'Suggestion Details'**
  String get improveHeading;

  /// No description provided for @improveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your improvement suggestion'**
  String get improveSubtitle;

  /// No description provided for @improveDeptLabel.
  ///
  /// In en, this message translates to:
  /// **'Target Department (Optional)'**
  String get improveDeptLabel;

  /// No description provided for @improveDeptHint.
  ///
  /// In en, this message translates to:
  /// **'Select Department'**
  String get improveDeptHint;

  /// No description provided for @improveSuggestionLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Suggestion *'**
  String get improveSuggestionLabel;

  /// No description provided for @improveSuggestionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your improvement suggestion in detail...'**
  String get improveSuggestionHint;

  /// No description provided for @improveNextLocation.
  ///
  /// In en, this message translates to:
  /// **'Next: Location →'**
  String get improveNextLocation;

  /// No description provided for @improveLocationHeading.
  ///
  /// In en, this message translates to:
  /// **'Location (Optional)'**
  String get improveLocationHeading;

  /// No description provided for @improveLocationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Where should this improvement be made?'**
  String get improveLocationSubtitle;

  /// No description provided for @improveLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location / Area'**
  String get improveLocationLabel;

  /// No description provided for @improveLocationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Near the main market'**
  String get improveLocationHint;

  /// No description provided for @improveLandmarkLabel.
  ///
  /// In en, this message translates to:
  /// **'Landmark (Optional)'**
  String get improveLandmarkLabel;

  /// No description provided for @improveLandmarkHint.
  ///
  /// In en, this message translates to:
  /// **'Nearby landmark'**
  String get improveLandmarkHint;

  /// No description provided for @improveNextReview.
  ///
  /// In en, this message translates to:
  /// **'Next: Review →'**
  String get improveNextReview;

  /// No description provided for @improveReviewHeading.
  ///
  /// In en, this message translates to:
  /// **'Review your suggestion'**
  String get improveReviewHeading;

  /// No description provided for @improveReviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please review before submitting'**
  String get improveReviewSubtitle;

  /// No description provided for @improveCardDetails.
  ///
  /// In en, this message translates to:
  /// **'Suggestion Details'**
  String get improveCardDetails;

  /// No description provided for @improveRowDept.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get improveRowDept;

  /// No description provided for @improveRowSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get improveRowSuggestion;

  /// No description provided for @improveRowLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get improveRowLocation;

  /// No description provided for @improveRowLandmark.
  ///
  /// In en, this message translates to:
  /// **'Landmark'**
  String get improveRowLandmark;

  /// No description provided for @improveSubmitBtn.
  ///
  /// In en, this message translates to:
  /// **'Submit Suggestion'**
  String get improveSubmitBtn;

  /// No description provided for @improveSuccessMsg.
  ///
  /// In en, this message translates to:
  /// **'Our team will review your suggestion and take appropriate action.'**
  String get improveSuccessMsg;

  /// No description provided for @improveGoHome.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get improveGoHome;

  /// No description provided for @yesLabel.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesLabel;

  /// No description provided for @noLabel.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noLabel;

  /// No description provided for @maximumReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum reached'**
  String get maximumReached;

  /// No description provided for @maximumFilesMsg.
  ///
  /// In en, this message translates to:
  /// **'Maximum 10 files allowed'**
  String get maximumFilesMsg;

  /// No description provided for @stepDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get stepDetails;

  /// No description provided for @stepVisibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get stepVisibility;

  /// No description provided for @stepReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get stepReview;

  /// No description provided for @stepDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get stepDone;

  /// No description provided for @stepImpact.
  ///
  /// In en, this message translates to:
  /// **'Impact'**
  String get stepImpact;

  /// No description provided for @stepRecipient.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get stepRecipient;

  /// No description provided for @stepMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get stepMessage;

  /// No description provided for @stepSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggestion'**
  String get stepSuggestion;

  /// No description provided for @stepLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get stepLocation;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ml'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SEn();
    case 'ml':
      return SMl();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
