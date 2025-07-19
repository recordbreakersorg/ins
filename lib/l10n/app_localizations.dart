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

  /// No description provided for @acceptContinue.
  ///
  /// In en, this message translates to:
  /// **'Accept & Continue'**
  String get acceptContinue;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @accountCreatedSuccesfuly.
  ///
  /// In en, this message translates to:
  /// **'#Account succefsully created'**
  String get accountCreatedSuccesfuly;

  /// No description provided for @couldNotSaveAppState.
  ///
  /// In en, this message translates to:
  /// **'Could not save app State'**
  String get couldNotSaveAppState;

  /// No description provided for @invalidDomainComponent.
  ///
  /// In en, this message translates to:
  /// **'Invalid domain component'**
  String get invalidDomainComponent;

  /// No description provided for @loadingTerms.
  ///
  /// In en, this message translates to:
  /// **'Loading terms of service'**
  String get loadingTerms;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @noSchoolFound.
  ///
  /// In en, this message translates to:
  /// **'No school found'**
  String get noSchoolFound;

  /// No description provided for @nothingHere.
  ///
  /// In en, this message translates to:
  /// **'Nothing here'**
  String get nothingHere;

  /// No description provided for @errorLoadingYourDashboard.
  ///
  /// In en, this message translates to:
  /// **'Error loading your dashboard'**
  String get errorLoadingYourDashboard;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @welcomeToIS.
  ///
  /// In en, this message translates to:
  /// **'Welcome to IS'**
  String get welcomeToIS;

  /// No description provided for @emailShouldContain1.
  ///
  /// In en, this message translates to:
  /// **'Email should contain 1 \'@\''**
  String get emailShouldContain1;

  /// No description provided for @whatDoYouWantToApplyFor.
  ///
  /// In en, this message translates to:
  /// **'What do you want to apply for?'**
  String get whatDoYouWantToApplyFor;

  /// No description provided for @wasNotTranslated.
  ///
  /// In en, this message translates to:
  /// **'Was not translated'**
  String get wasNotTranslated;

  /// No description provided for @students.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get students;

  /// No description provided for @sloganShort.
  ///
  /// In en, this message translates to:
  /// **'Empowering connections, empowering futures'**
  String get sloganShort;

  /// No description provided for @optionalInformations.
  ///
  /// In en, this message translates to:
  /// **'#Informations optionnelles'**
  String get optionalInformations;

  /// No description provided for @waitingMessages.
  ///
  /// In en, this message translates to:
  /// **'We\'re getting this done...|Please wait a little more...|Things are going as expected...|...|Wait once more...|A few moments...'**
  String get waitingMessages;

  /// No description provided for @invalidEmailDomainsecondPart.
  ///
  /// In en, this message translates to:
  /// **'#Domaine de l\'e-mail invalide (deuxième partie)'**
  String get invalidEmailDomainsecondPart;

  /// No description provided for @couldNotGetSchooolApplicationForms.
  ///
  /// In en, this message translates to:
  /// **'#Nous n\'avons pas pu recevoid les formulaires d\'inscription'**
  String get couldNotGetSchooolApplicationForms;

  /// No description provided for @passwordShouldHaveAtLeast8Characters.
  ///
  /// In en, this message translates to:
  /// **'Password should have at least 8 characters length'**
  String get passwordShouldHaveAtLeast8Characters;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @openDashboard.
  ///
  /// In en, this message translates to:
  /// **'Open dashboard'**
  String get openDashboard;

  /// No description provided for @editPreferences.
  ///
  /// In en, this message translates to:
  /// **'Edit Preferences'**
  String get editPreferences;

  /// No description provided for @addEmailaoPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'#Renseigner une adresse e-mail et/ou un numéro de téléphone'**
  String get addEmailaoPhoneNumber;

  /// No description provided for @campus.
  ///
  /// In en, this message translates to:
  /// **'Campus'**
  String get campus;

  /// No description provided for @applyNow.
  ///
  /// In en, this message translates to:
  /// **'Apply Now'**
  String get applyNow;

  /// No description provided for @usernameDesc.
  ///
  /// In en, this message translates to:
  /// **'A short public name visible by others'**
  String get usernameDesc;

  /// No description provided for @usernameMustHaveBetween4And20Characters.
  ///
  /// In en, this message translates to:
  /// **'###Le nom d\'utilisateur doit contenir entre 3 et 20 caractères'**
  String get usernameMustHaveBetween4And20Characters;

  /// No description provided for @helloWorldOfThings.
  ///
  /// In en, this message translates to:
  /// **'hello world of things'**
  String get helloWorldOfThings;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @connectAccount.
  ///
  /// In en, this message translates to:
  /// **'Connect account'**
  String get connectAccount;

  /// No description provided for @usernameMustHaveBetween3And20Characters.
  ///
  /// In en, this message translates to:
  /// **'Username must have between 3 and 20 characters'**
  String get usernameMustHaveBetween3And20Characters;

  /// No description provided for @emailShouldContain.
  ///
  /// In en, this message translates to:
  /// **'Email should contain \'@\''**
  String get emailShouldContain;

  /// No description provided for @continueGt.
  ///
  /// In en, this message translates to:
  /// **'Continue >'**
  String get continueGt;

  /// No description provided for @accountCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get accountCreatedSuccessfully;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @optionalInformation.
  ///
  /// In en, this message translates to:
  /// **'Optional information'**
  String get optionalInformation;

  /// No description provided for @pleaseReviewAndAcceptOurTermsAndConditionsToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please review and accept our terms and conditions to continue.'**
  String get pleaseReviewAndAcceptOurTermsAndConditionsToContinue;

  /// No description provided for @signupAssistant_phoneNumberError.
  ///
  /// In en, this message translates to:
  /// **'Phone number should be 9 digits long (without country code)'**
  String get signupAssistant_phoneNumberError;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @homeLoadingMessages.
  ///
  /// In en, this message translates to:
  /// **'Loading app state...|Verifying user details...|Getting permissions from your schools..|Verifying the age on your birth certificate...|Please wait...|Almost there...'**
  String get homeLoadingMessages;

  /// No description provided for @atAGlance.
  ///
  /// In en, this message translates to:
  /// **'At a Glance'**
  String get atAGlance;

  /// No description provided for @browseSchools.
  ///
  /// In en, this message translates to:
  /// **'Browse Schools'**
  String get browseSchools;

  /// No description provided for @thisUsernameIsAlreadyTaken.
  ///
  /// In en, this message translates to:
  /// **'This username is already taken'**
  String get thisUsernameIsAlreadyTaken;

  /// No description provided for @creatingYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating your account'**
  String get creatingYourAccount;

  /// No description provided for @emailNameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Email name too short'**
  String get emailNameTooShort;

  /// No description provided for @loadingYourDashboard.
  ///
  /// In en, this message translates to:
  /// **'Loading your dashboard'**
  String get loadingYourDashboard;

  /// No description provided for @couldNotGetSchoolApplicationForms.
  ///
  /// In en, this message translates to:
  /// **'Could not get school application forms'**
  String get couldNotGetSchoolApplicationForms;

  /// No description provided for @welcomeExcl.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcomeExcl;

  /// No description provided for @schoolApplication.
  ///
  /// In en, this message translates to:
  /// **'School Application'**
  String get schoolApplication;

  /// No description provided for @noDescriptionProvided.
  ///
  /// In en, this message translates to:
  /// **'No description provided.'**
  String get noDescriptionProvided;

  /// No description provided for @errorLoadingTerms.
  ///
  /// In en, this message translates to:
  /// **'Error loading terms of service'**
  String get errorLoadingTerms;

  /// No description provided for @areWeGoing.
  ///
  /// In en, this message translates to:
  /// **'Are we going?'**
  String get areWeGoing;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @reenterPassword.
  ///
  /// In en, this message translates to:
  /// **'Re-enter password'**
  String get reenterPassword;

  /// No description provided for @signin.
  ///
  /// In en, this message translates to:
  /// **'Signin'**
  String get signin;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @loginInformations.
  ///
  /// In en, this message translates to:
  /// **'Login information'**
  String get loginInformations;

  /// No description provided for @invalidCharacterInEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid character in email '**
  String get invalidCharacterInEmail;

  /// No description provided for @exploreSchools.
  ///
  /// In en, this message translates to:
  /// **'Explore Schools'**
  String get exploreSchools;

  /// No description provided for @invalidEmailDomainSecondPart.
  ///
  /// In en, this message translates to:
  /// **'Invalid email domain (second part)'**
  String get invalidEmailDomainSecondPart;

  /// No description provided for @iHaveReadAndAgreeToTheTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree to the terms and conditions.'**
  String get iHaveReadAndAgreeToTheTermsAndConditions;

  /// No description provided for @welcomeConnectOrCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Connect an existing account or create a new one to embark on your journey with us'**
  String get welcomeConnectOrCreateAccount;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get termsAndConditions;

  /// No description provided for @addEmailOrPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Add email or phone number'**
  String get addEmailOrPhoneNumber;

  /// No description provided for @establishedIn2023.
  ///
  /// In en, this message translates to:
  /// **'Established in 2023'**
  String get establishedIn2023;

  /// No description provided for @passwordShouldHaveAtleast8Characters.
  ///
  /// In en, this message translates to:
  /// **'#Le mot de passe doit contenir au moins 8 caractères'**
  String get passwordShouldHaveAtleast8Characters;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccount;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;
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
