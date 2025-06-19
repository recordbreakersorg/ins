import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
    Locale('fr'),
  ];

  /// The conventional newborn programmer greeting
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// Error message when the user's session fails to load
  ///
  /// In en, this message translates to:
  /// **'Error loading your session'**
  String get errorLoadingYourSession;

  /// Action to reload the current page or data
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get reload;

  /// Action to log out the user
  ///
  /// In en, this message translates to:
  /// **'logout'**
  String get logout;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Message indicating that the user's online accounts are being loaded
  ///
  /// In en, this message translates to:
  /// **'Loading your online accounts...'**
  String get loadingYourOnlineAccounts;

  /// Welcome message for the Intranet of Schools platform
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Intranet of Schools'**
  String get welcomeToTheIntranetOfSchools;

  /// Error message including a snapshot of the error
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorSnapshotError(Object error);

  /// Label for the user's schools
  ///
  /// In en, this message translates to:
  /// **'Your schools'**
  String get yourSchools;

  /// Label for the main dashboard
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Label for the schedule section
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// Label for the classrooms section
  ///
  /// In en, this message translates to:
  /// **'Classrooms'**
  String get classrooms;

  /// Label for the user's profile
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Label for the application settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Action to sign out
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Welcome back message
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// Base content for the dashboard
  ///
  /// In en, this message translates to:
  /// **'Dashboard Base Content'**
  String get dashboardBaseContent;

  /// Generic welcome
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// Label to connect
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// Label to register
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// Label for schools
  ///
  /// In en, this message translates to:
  /// **'Schools'**
  String get schools;

  /// Label for home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Label for Intranet of Schools
  ///
  /// In en, this message translates to:
  /// **'Intranet of Schools'**
  String get intranetOfSchools;

  /// Message when there are no schools
  ///
  /// In en, this message translates to:
  /// **'No schools'**
  String get noSchools;

  /// Message when the user is not a member of any school
  ///
  /// In en, this message translates to:
  /// **'You are a member of no school yet'**
  String get noSchoolMembership;

  /// Label to explore
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// Message indicating the user is not a member of a school
  ///
  /// In en, this message translates to:
  /// **'You are a member of no school yet'**
  String get youAreAMemberOfNoSchoolYet;

  /// Message indicating a waiting period
  ///
  /// In en, this message translates to:
  /// **'Wait a little bit ...'**
  String get waitALittleBit;

  /// Label for manual signup
  ///
  /// In en, this message translates to:
  /// **'Manual Signup >'**
  String get manualSignup;

  /// Message after successful signup
  ///
  /// In en, this message translates to:
  /// **'Successfully signed up'**
  String get successfullySignedUp;

  /// Label for name input
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// Label for password input
  ///
  /// In en, this message translates to:
  /// **'Your password'**
  String get yourPassword;

  /// Label for sign in
  ///
  /// In en, this message translates to:
  /// **'Signin >'**
  String get signin;

  /// Question asking the user's role
  ///
  /// In en, this message translates to:
  /// **'What role best fits you?'**
  String get whatRoleBestFitsYou;

  /// Label for student role
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// Label for instructor role
  ///
  /// In en, this message translates to:
  /// **'Instructor'**
  String get instructor;

  /// Label for administrator role
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get administrator;

  /// Label for parent role
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get parent;

  /// Label for role selection
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// Label for weak password strength
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get weak;

  /// Label for moderate password strength
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// Label for strong password strength
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get strong;

  /// Label for suggested password
  ///
  /// In en, this message translates to:
  /// **'Suggested Password'**
  String get suggestedPassword;

  /// Label to cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Label to copy
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// Label to use
  ///
  /// In en, this message translates to:
  /// **'Use This'**
  String get useThis;

  /// Label for password
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Label to generate password
  ///
  /// In en, this message translates to:
  /// **'Generate password'**
  String get generatePassword;

  /// Label for minimum password length
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters'**
  String get minimum8Characters;

  /// Label for number requirement in password
  ///
  /// In en, this message translates to:
  /// **'Number (0-9)'**
  String get number09;

  /// Label for lowercase requirement in password
  ///
  /// In en, this message translates to:
  /// **'Lowercase letter (a-z)'**
  String get lowercaseLetterAZ;

  /// Label for special character requirement in password
  ///
  /// In en, this message translates to:
  /// **'Special character (!@#...)'**
  String get specialCharacter;

  /// Label for uppercase requirement in password
  ///
  /// In en, this message translates to:
  /// **'Uppercase letter (A-Z)'**
  String get uppercaseLetterAZ;

  /// Label to continue
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continuer;

  /// Label for password strength
  ///
  /// In en, this message translates to:
  /// **'\$_strengthLabel password'**
  String strengthlabelPassword(Object _strengthLabel);

  /// Label to create user profile
  ///
  /// In en, this message translates to:
  /// **'Create Your Profile'**
  String get createYourProfile;

  /// Label for full name input
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Label for username input
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// Label for profile setup section
  ///
  /// In en, this message translates to:
  /// **'Profile Setup'**
  String get profileSetup;

  /// Message indicating username availability check
  ///
  /// In en, this message translates to:
  /// **'Checking username availability...'**
  String get checkingUsernameAvailability;

  /// Message indicating username requirements
  ///
  /// In en, this message translates to:
  /// **'Username must be at least 3 characters and can only contain:\\nlowercase letters, numbers, underscores (_), and periods (.)'**
  String
  get usernameMustBeAtLeast3CharactersAndCanOnlyContainNlowercaseLettersNumbersUnderscoresAndPeriods;

  /// Message indicating username is taken
  ///
  /// In en, this message translates to:
  /// **'This username is already taken'**
  String get thisUsernameIsAlreadyTaken;

  /// Message prompting user to select date of birth
  ///
  /// In en, this message translates to:
  /// **'Please select a date of birth.'**
  String get pleaseSelectADateOfBirth;

  /// Label for date of birth
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// Label to choose date of birth
  ///
  /// In en, this message translates to:
  /// **'Choose your date of birth'**
  String get chooseYourDateOfBirth;

  /// Label to select a date
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// Message indicating new account setup
  ///
  /// In en, this message translates to:
  /// **'Setting up your new account...'**
  String get settingUpYourNewAccount;

  /// Message indicating workspace preparation
  ///
  /// In en, this message translates to:
  /// **'Preparing your workspace...'**
  String get preparingYourWorkspace;

  /// Message indicating settings configuration
  ///
  /// In en, this message translates to:
  /// **'Configuring settings...'**
  String get configuringSettings;

  /// Message indicating nearing completion
  ///
  /// In en, this message translates to:
  /// **'Almost there...'**
  String get almostThere;

  /// Message indicating a short wait
  ///
  /// In en, this message translates to:
  /// **'Just a few more moments...'**
  String get justAFewMoreMoments;

  /// Message indicating profile creation
  ///
  /// In en, this message translates to:
  /// **'Creating your profile...'**
  String get creatingYourProfile;

  /// Message indicating preference setup
  ///
  /// In en, this message translates to:
  /// **'Setting up your preferences...'**
  String get settingUpYourPreferences;

  /// Message indicating account finalization
  ///
  /// In en, this message translates to:
  /// **'Finalizing your account...'**
  String get finalizingYourAccount;

  /// Message indicating dashboard loading
  ///
  /// In en, this message translates to:
  /// **'Loading your dashboard...'**
  String get loadingYourDashboard;

  /// Message indicating account creation
  ///
  /// In en, this message translates to:
  /// **'Creating your account'**
  String get creatingYourAccount;

  /// Message indicating account creation failure
  ///
  /// In en, this message translates to:
  /// **'Account creation failed'**
  String get accountCreationFailed;

  /// Message indicating successful account creation
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreatedSuccessfully;

  /// Message welcoming user to new account
  ///
  /// In en, this message translates to:
  /// **'Welcome to your new account!'**
  String get welcomeToYourNewAccount;

  /// Generic location
  ///
  /// In en, this message translates to:
  /// **'Somewhere'**
  String get somewhere;

  /// Label to start an application
  ///
  /// In en, this message translates to:
  /// **'Start Application'**
  String get startApplication;

  /// Label to explore schools
  ///
  /// In en, this message translates to:
  /// **'Explore Schools'**
  String get exploreSchools;

  /// Label to dismiss
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// Label to view
  ///
  /// In en, this message translates to:
  /// **'View >'**
  String get view;

  /// Message indicating loading feeds
  ///
  /// In en, this message translates to:
  /// **'Loading your feeds...'**
  String get loadingYourFeeds;

  /// Message indicating to cross fingers
  ///
  /// In en, this message translates to:
  /// **'Cross your fingers'**
  String get crossYourFingers;

  /// Message indicating to wait
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// Error message when feeds fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading your feeds'**
  String get errorLoadingYourFeeds;

  /// Message indicating all content is viewed
  ///
  /// In en, this message translates to:
  /// **'All caught up!'**
  String get allCaughtUp;

  /// Error message when classrooms fail to load
  ///
  /// In en, this message translates to:
  /// **'Unable to load classrooms'**
  String get unableToLoadClassrooms;

  /// Message indicating no classrooms
  ///
  /// In en, this message translates to:
  /// **'No classrooms'**
  String get noClassrooms;

  /// Message indicating user is not a member of any classroom
  ///
  /// In en, this message translates to:
  /// **'You are not a member of any classroom yet'**
  String get youAreNotAMemberOfAnyClassroomYet;

  /// Generic loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Message indicating form retrieval
  ///
  /// In en, this message translates to:
  /// **'Getting form...'**
  String get gettingForm;

  /// Label for instructions
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// Label for next action
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Label for next step
  ///
  /// In en, this message translates to:
  /// **'Next Step'**
  String get nextStep;

  /// Message indicating next step of application
  ///
  /// In en, this message translates to:
  /// **'Next step of the application goes here.'**
  String get nextStepOfTheApplicationGoesHere;

  /// Message indicating a required question
  ///
  /// In en, this message translates to:
  /// **'This question is required'**
  String get thisQuestionIsRequired;

  /// Message prompting user to enter their answer
  ///
  /// In en, this message translates to:
  /// **'Enter your answer'**
  String get enterYourAnswer;

  /// Message indicating a required field
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get thisFieldIsRequired;

  /// Message indicating to tap to select a date
  ///
  /// In en, this message translates to:
  /// **'Tap to select date'**
  String get tapToSelectDate;

  /// Label to submit application
  ///
  /// In en, this message translates to:
  /// **'Submit Application'**
  String get submitApplication;

  /// Shows the current question number and total number of questions
  ///
  /// In en, this message translates to:
  /// **'question {index} of {length}'**
  String questionXofX(int index, int length);

  /// Error message for timed out request
  ///
  /// In en, this message translates to:
  /// **'Request timed out. Please check your connection.'**
  String get requestTimedOutPleaseCheckYourConnection;

  /// Error message for network error
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your internet connection.'**
  String get networkErrorPleaseCheckYourInternetConnection;

  /// Error message for failed submission
  ///
  /// In en, this message translates to:
  /// **'Submission failed. Please try again.'**
  String get submissionFailedPleaseTryAgain;

  /// Message indicating form submission
  ///
  /// In en, this message translates to:
  /// **'Submitting form...'**
  String get submittingForm;

  /// Message indicating information processing
  ///
  /// In en, this message translates to:
  /// **'Almost there! Processing your information...'**
  String get almostThereProcessingYourInformation;

  /// Message indicating submission finalization
  ///
  /// In en, this message translates to:
  /// **'Finalizing your submission...'**
  String get finalizingYourSubmission;

  /// Message after successful submission
  ///
  /// In en, this message translates to:
  /// **'Submission Successful!'**
  String get submissionSuccessful;

  /// Message indicating successful form submission
  ///
  /// In en, this message translates to:
  /// **'Your form has been submitted successfully.'**
  String get yourFormHasBeenSubmittedSuccessfully;

  /// Message indicating a confirmation email will be sent
  ///
  /// In en, this message translates to:
  /// **'You will receive a confirmation email shortly.'**
  String get youWillReceiveAConfirmationEmailShortly;

  /// Label to return to dashboard
  ///
  /// In en, this message translates to:
  /// **'Return to Dashboard'**
  String get returnToDashboard;

  /// Message indicating submission failure
  ///
  /// In en, this message translates to:
  /// **'Submission Failed'**
  String get submissionFailed;

  /// Message prompting user to check information and try again
  ///
  /// In en, this message translates to:
  /// **'Please check your information and try again.'**
  String get pleaseCheckYourInformationAndTryAgain;

  /// Label to try again
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// Label to go back
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// Error message when the application form fails to load
  ///
  /// In en, this message translates to:
  /// **'Error loading application form'**
  String get errorLoadingApplicationForm;

  /// Message to select an application form
  ///
  /// In en, this message translates to:
  /// **'Select application form'**
  String get selectApplicationForm;

  /// No description provided for @banana.
  ///
  /// In en, this message translates to:
  /// **'banana'**
  String get banana;

  /// No description provided for @schoolApplications.
  ///
  /// In en, this message translates to:
  /// **'School Applications'**
  String get schoolApplications;

  /// No description provided for @gettingAllSchoolMembers.
  ///
  /// In en, this message translates to:
  /// **'Getting all school members...'**
  String get gettingAllSchoolMembers;

  /// No description provided for @crunchingDatabaseRecords.
  ///
  /// In en, this message translates to:
  /// **'Crunching database records...'**
  String get crunchingDatabaseRecords;

  /// No description provided for @schoolMembers.
  ///
  /// In en, this message translates to:
  /// **'School Members'**
  String get schoolMembers;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @gettingAllSchoolApplications.
  ///
  /// In en, this message translates to:
  /// **'Getting all school applications'**
  String get gettingAllSchoolApplications;

  /// No description provided for @errorGettingApplicationsAttempts.
  ///
  /// In en, this message translates to:
  /// **'Error getting applications attempts'**
  String get errorGettingApplicationsAttempts;

  /// No description provided for @applicationAccepted.
  ///
  /// In en, this message translates to:
  /// **'Application accepted.'**
  String get applicationAccepted;

  /// No description provided for @applicationDeclined.
  ///
  /// In en, this message translates to:
  /// **'Application declined.'**
  String get applicationDeclined;

  /// No description provided for @reviewApplication.
  ///
  /// In en, this message translates to:
  /// **'Review Application'**
  String get reviewApplication;

  /// No description provided for @noAnswer.
  ///
  /// In en, this message translates to:
  /// **'(No answer)'**
  String get noAnswer;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @selectTheRoleForTheNewUser.
  ///
  /// In en, this message translates to:
  /// **'Select the role for the new user:'**
  String get selectTheRoleForTheNewUser;

  /// No description provided for @teacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get teacher;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
