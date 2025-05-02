// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get helloWorld => 'Bonjour le monde !';

  @override
  String get errorLoadingYourSession => 'Erreur lors du chargement de votre session';

  @override
  String get reload => 'Recharger';

  @override
  String get logout => 'Se déconnecter';

  @override
  String get error => 'Erreur';

  @override
  String get loadingYourOnlineAccounts => 'Chargement de vos comptes en ligne...';

  @override
  String get welcomeToTheIntranetOfSchools => 'Bienvenue sur l\'Intranet des Écoles';

  @override
  String errorSnapshotError(Object error) {
    return 'Erreur : $error';
  }

  @override
  String get yourSchools => 'Vos écoles';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get schedule => 'Emploi du temps';

  @override
  String get classrooms => 'Salles de classe';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Paramètres';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get welcomeBack => 'Bon retour';

  @override
  String get dashboardBaseContent => 'Contenu de base du tableau de bord';

  @override
  String get welcome => 'Bienvenue !';

  @override
  String get connect => 'Se connecter';

  @override
  String get register => 'S\'inscrire';

  @override
  String get schools => 'Écoles';

  @override
  String get home => 'Home';

  @override
  String get intranetOfSchools => 'Intranet des Écoles';

  @override
  String get noSchools => 'Aucune école';

  @override
  String get noSchoolMembership => 'Vous n\'êtes membre d\'aucune école pour le moment';

  @override
  String get explore => 'Explorer';

  @override
  String get youAreAMemberOfNoSchoolYet => 'Vous n\'êtes membre d\'aucune école pour le moment';

  @override
  String get waitALittleBit => 'Patientez un instant...';

  @override
  String get manualSignup => 'Inscription manuelle >';

  @override
  String get successfullySignedUp => 'Inscription réussie';

  @override
  String get yourName => 'Votre nom';

  @override
  String get yourPassword => 'Votre mot de passe';

  @override
  String get signin => 'Se connecter >';

  @override
  String get whatRoleBestFitsYou => 'Quel rôle vous correspond le mieux ?';

  @override
  String get student => 'Student';

  @override
  String get instructor => 'Professeur';

  @override
  String get administrator => 'Administrateur';

  @override
  String get parent => 'Parent';

  @override
  String get role => 'Rôle';

  @override
  String get weak => 'Faible';

  @override
  String get moderate => 'Moyen';

  @override
  String get strong => 'Fort';

  @override
  String get suggestedPassword => 'Mot de passe suggéré';

  @override
  String get cancel => 'Annuler';

  @override
  String get copy => 'Copier';

  @override
  String get useThis => 'Utiliser';

  @override
  String get password => 'Mot de passe';

  @override
  String get generatePassword => 'Générer un mot de passe';

  @override
  String get minimum8Characters => 'Minimum 8 caractères';

  @override
  String get number09 => 'Chiffre (0-9)';

  @override
  String get lowercaseLetterAZ => 'Lettre minuscule (a-z)';

  @override
  String get specialCharacter => 'Caractère spécial (!@#...)';

  @override
  String get uppercaseLetterAZ => 'Lettre majuscule (A-Z)';

  @override
  String get continuer => 'Continuer';

  @override
  String strengthlabelPassword(Object _strengthLabel) {
    return 'Mot de passe \$_strengthLabel';
  }

  @override
  String get createYourProfile => 'Créer votre profil';

  @override
  String get fullName => 'Nom complet';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get profileSetup => 'Configuration du profil';

  @override
  String get checkingUsernameAvailability => 'Vérification de la disponibilité du nom d\'utilisateur...';

  @override
  String get usernameMustBeAtLeast3CharactersAndCanOnlyContainNlowercaseLettersNumbersUnderscoresAndPeriods => 'Le nom d\'utilisateur doit comporter au moins 3 caractères et ne peut contenir que :\ndes lettres minuscules, des chiffres, des underscores (_) et des points (.)';

  @override
  String get thisUsernameIsAlreadyTaken => 'Ce nom d\'utilisateur est déjà pris';

  @override
  String get pleaseSelectADateOfBirth => 'Veuillez sélectionner une date de naissance.';

  @override
  String get dateOfBirth => 'Date de naissance';

  @override
  String get chooseYourDateOfBirth => 'Choisissez votre date de naissance';

  @override
  String get selectDate => 'Sélectionner une date';

  @override
  String get settingUpYourNewAccount => 'Configuration de votre nouveau compte...';

  @override
  String get preparingYourWorkspace => 'Préparation de votre espace de travail...';

  @override
  String get configuringSettings => 'Configuration des paramètres...';

  @override
  String get almostThere => 'Presque là...';

  @override
  String get justAFewMoreMoments => 'Encore quelques instants...';

  @override
  String get creatingYourProfile => 'Création de votre profil...';

  @override
  String get settingUpYourPreferences => 'Configuration de vos préférences...';

  @override
  String get finalizingYourAccount => 'Finalisation de votre compte...';

  @override
  String get loadingYourDashboard => 'Chargement de votre tableau de bord...';

  @override
  String get creatingYourAccount => 'Création de votre compte';

  @override
  String get accountCreationFailed => 'La création du compte a échoué';

  @override
  String get accountCreatedSuccessfully => 'Compte créé avec succès !';

  @override
  String get welcomeToYourNewAccount => 'Bienvenue sur votre nouveau compte !';

  @override
  String get somewhere => 'Quelque part';

  @override
  String get startApplication => 'Démarrer l\'application';

  @override
  String get exploreSchools => 'Explorer les écoles';

  @override
  String get dismiss => 'Ignorer';

  @override
  String get view => 'Voir >';

  @override
  String get loadingYourFeeds => 'Chargement de vos flux...';

  @override
  String get crossYourFingers => 'Croisez les doigts';

  @override
  String get pleaseWait => 'Please wait...';

  @override
  String get errorLoadingYourFeeds => 'Erreur lors du chargement de vos flux';

  @override
  String get allCaughtUp => 'Tout est à jour !';

  @override
  String get unableToLoadClassrooms => 'Impossible de charger les salles de classe';

  @override
  String get noClassrooms => 'Aucune salle de classe';

  @override
  String get youAreNotAMemberOfAnyClassroomYet => 'Vous n\'êtes membre d\'aucune salle de classe pour le moment';

  @override
  String get loading => 'Chargement...';

  @override
  String get gettingForm => 'Récupération du formulaire...';

  @override
  String get instructions => 'Instructions';

  @override
  String get next => 'Suivant';

  @override
  String get nextStep => 'Étape suivante';

  @override
  String get nextStepOfTheApplicationGoesHere => 'La prochaine étape de la demande se trouve ici.';

  @override
  String get thisQuestionIsRequired => 'Cette question est obligatoire';

  @override
  String get enterYourAnswer => 'Entrez votre réponse';

  @override
  String get thisFieldIsRequired => 'Ce champ est obligatoire';

  @override
  String get tapToSelectDate => 'Appuyez pour sélectionner la date';

  @override
  String get submitApplication => 'Soumettre la demande';

  @override
  String questionXofX(int index, int length) {
    return 'Question $index sur $length';
  }

  @override
  String get requestTimedOutPleaseCheckYourConnection => 'La requête a expiré. Veuillez vérifier votre connexion.';

  @override
  String get networkErrorPleaseCheckYourInternetConnection => 'Erreur réseau. Veuillez vérifier votre connexion Internet.';

  @override
  String get submissionFailedPleaseTryAgain => 'La soumission a échoué. Veuillez réessayer.';

  @override
  String get submittingForm => 'Soumission du formulaire...';

  @override
  String get almostThereProcessingYourInformation => 'Presque là ! Traitement de vos informations...';

  @override
  String get finalizingYourSubmission => 'Finalisation de votre soumission...';

  @override
  String get submissionSuccessful => 'Soumission réussie !';

  @override
  String get yourFormHasBeenSubmittedSuccessfully => 'Votre formulaire a été soumis avec succès.';

  @override
  String get youWillReceiveAConfirmationEmailShortly => 'Vous recevrez un e-mail de confirmation sous peu.';

  @override
  String get returnToDashboard => 'Retour au tableau de bord';

  @override
  String get submissionFailed => 'Échec de la soumission';

  @override
  String get pleaseCheckYourInformationAndTryAgain => 'Veuillez vérifier vos informations et réessayer.';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get goBack => 'Retourner';

  @override
  String get errorLoadingApplicationForm => 'Erreur lors du chargement du formulaire de demande';

  @override
  String get selectApplicationForm => 'Sélectionner le formulaire de demande';

  @override
  String get banana => 'banana';

  @override
  String get schoolApplications => 'School Applications';

  @override
  String get gettingAllSchoolMembers => 'Getting all school members...';

  @override
  String get crunchingDatabaseRecords => 'Crunching database records...';

  @override
  String get schoolMembers => 'School Members';

  @override
  String get exit => 'Exit';

  @override
  String get gettingAllSchoolApplications => 'Getting all school applications';

  @override
  String get errorGettingApplicationsAttempts => 'Error getting applications attempts';

  @override
  String get applicationAccepted => 'Application accepted.';

  @override
  String get applicationDeclined => 'Application declined.';

  @override
  String get reviewApplication => 'Review Application';

  @override
  String get noAnswer => '(No answer)';

  @override
  String get accept => 'Accept';

  @override
  String get decline => 'Decline';

  @override
  String get selectTheRoleForTheNewUser => 'Select the role for the new user:';

  @override
  String get teacher => 'Teacher';

  @override
  String get admin => 'Admin';
}
