// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get homeLoadingMessages =>
      'Verification des details d\'utilisateur...|Acquisition de permission de votre ecole..|Veuillez patienter...|Nous y sommes presque...';

  @override
  String get welcomeExcl => 'Bienvenue!';

  @override
  String get welcomeToIS => 'Bienvenue sur IS';

  @override
  String get welcomeConnectOrCreateAccount =>
      'Connectez un compte existant ou creez en un nouveau pour utiliser IS';

  @override
  String get connectAccount => 'Connectez votre compte';

  @override
  String get createAccount => 'Creez un compte';

  @override
  String get sloganShort =>
      'Construire des liens puissants, bâtir des avenirs prometteurs';

  @override
  String get optionalInformations => 'Informations optionelles';

  @override
  String get emailAddress => 'Addresse email';

  @override
  String get phoneNumber => 'Numero de telephone';

  @override
  String get signupAssistant_phoneNumberError =>
      'Le numero devrais faire 9 chiffres de long (Sans code iso)';

  @override
  String get addEmailaoPhoneNumber =>
      'Renseigner une addresse email et/ou numero de telephone';

  @override
  String get fullName => 'Nom complet';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get usernameDesc => 'Un surnom court, et visible des autres';

  @override
  String get password => 'Mot de passe';

  @override
  String get reenterPassword => 'Re-entrez votre mot de passe';

  @override
  String get loginInformations => 'Informations de connection';

  @override
  String get passwordsDoNotMatch => 'Les mot-de-passe ne coincident pas';

  @override
  String get passwordShouldHaveAtleast8Characters =>
      'Le mot-de-passe doit faire au moins 8 characteres de long';

  @override
  String get usernameMustHaveBetween4And20Characters =>
      'Le nom d\'utilisateur doit faire entre 3 et 20 characteres de long';

  @override
  String get thisUsernameIsAlreadyTaken =>
      'Ce nom d\'utilisateur est deja prit';

  @override
  String get creatingYourAccount => 'Nous creons votre compte';

  @override
  String get retry => 'Reessayer';

  @override
  String get accountCreatedSuccesfuly => 'Compte cree avec succes';

  @override
  String get openDashboard => 'Ouvrir le tableaux de bord';

  @override
  String get waitingMessages =>
      'Nous ourons bientot fini...|Attendez encore un peu...|Tout ce passe bien...|...|Un peu plus de temps...|Quelques instants d\'attente...';

  @override
  String get continueGt => 'Continuer >';

  @override
  String get loadingTerms => 'Loading terms of service';

  @override
  String get errorLoadingTerms => 'Error loading terms of service';

  @override
  String get termsAndConditions => 'Terms and Conditions';

  @override
  String get pleaseReviewAndAcceptOurTermsAndConditionsToContinue =>
      'Please review and accept our terms and conditions to continue.';
}
