import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ins/appstate.dart';
import 'package:ins/utils/logger.dart';

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  logger.i("Handling a background message: ${message.messageId}");
  // If you need to do work here, you'll need to initialize other services
  // like Firebase.initializeApp()
}

class FirebaseMessagingHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FirebaseMessagingHandler();

  /// Initializes the background message handler. Safe to call on every app launch.
  Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  /// Requests notification permission and registers the FCM token with the backend.
  /// This should be called after a user is authenticated.
  Future<void> requestPermissionAndRegisterToken() async {
    // Only proceed if there is a session
    final appState = await AppState.load();
    if (appState.session == null) {
      logger.i("No session, skipping FCM token registration.");
      return;
    }

    logger.i("Requesting notification permissions...");
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      logger.i('User granted permission. Registering FCM token.');
      await _registerToken();
      _setupTokenRefreshListener();
    } else {
      logger.i('User declined or has not accepted permission.');
    }
  }

  Future<void> _registerToken() async {
    final appState = await AppState.load();
    try {
      final fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken != null) {
        logger.i("FCM Token: $fcmToken");
        appState.session = await appState.session!.updateFCMToken(fcmToken);
        logger.i("FCM token successfully sent to backend.");
      } else {
        logger.w("Could not get FCM token.");
      }
    } catch (e) {
      logger.e("Error registering FCM token: $e");
    }
  }

  void _setupTokenRefreshListener() {
    _firebaseMessaging.onTokenRefresh
        .listen((fcmToken) async {
          final appState = await AppState.load();
          logger.i("FCM token refreshed: $fcmToken");
          // Ensure there's still a session before trying to update.
          if (appState.session != null) {
            appState.session!
                .updateFCMToken(fcmToken)
                .then((session) => appState.session = session)
                .catchError((e) {
                  logger.e("Error sending refreshed token to backend: $e");
                  return appState.session!;
                });
          }
        })
        .onError((err) {
          logger.e("FCM token refresh stream error: $err");
        });
  }
}
