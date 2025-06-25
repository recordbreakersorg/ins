// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeLoadingMessages =>
      'Loading app state...|Verifying user details...|Getting permissions from your schools..|Verifying the age on your birth certificate...|Please wait...|Almost there...';

  @override
  String get welcomeExcl => 'Welcome!';

  @override
  String get welcomeToIS => 'Welcome to IS';

  @override
  String get welcomeConnectOrCreateAccount =>
      'Connect an existing account or create a new one to embark on your journey with us';

  @override
  String get connectAccount => 'Connect account';

  @override
  String get createAccount => 'Create an account';

  @override
  String get sloganShort => 'Empowering connections, empowering futures';

  @override
  String get optionalInformations => 'Optional information';

  @override
  String get emailAddress => 'Email address';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get signupAssistant_phoneNumberError =>
      'Phone number should be 9 digits long (without country code)';

  @override
  String get addEmailaoPhoneNumber => 'Add email and/or phone number';

  @override
  String get fullName => 'Full name';

  @override
  String get username => 'Username';

  @override
  String get usernameDesc => 'A short public name visible by others';

  @override
  String get password => 'Password';

  @override
  String get reenterPassword => 'Reenter password';

  @override
  String get loginInformations => 'Login information';

  @override
  String get passwordsDoNotMatch => 'Password do not match';

  @override
  String get passwordShouldHaveAtleast8Characters =>
      'Password should have atleast 8 characters length';

  @override
  String get usernameMustHaveBetween4And20Characters =>
      'Username must have between 3 and 20 characters';

  @override
  String get thisUsernameIsAlreadyTaken => 'This username is already taken';

  @override
  String get creatingYourAccount => 'Creating you account';

  @override
  String get retry => 'Retry';

  @override
  String get accountCreatedSuccesfuly => 'Account created succesfuly';

  @override
  String get openDashboard => 'Open dashboard';

  @override
  String get waitingMessages =>
      'We\'re getting this done...|Please wait a little more...|Things are going as expected...|...|Wait once more...|A few moments...';
}
