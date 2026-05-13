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
  /// **'Ente MLA'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Your MLA. Your Voice.'**
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
  /// **'Welcome to Ente MLA'**
  String get allSetSubtitle;

  /// No description provided for @goToHome.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get goToHome;

  /// No description provided for @whatWouldYouLike.
  ///
  /// In en, this message translates to:
  /// **'What would you like to\nshare today?'**
  String get whatWouldYouLike;

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

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About Ente MLA'**
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
