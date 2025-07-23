import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ins/appstate.dart';
import 'package:ins/utils/logger.dart';

final FirebaseMessaging messaging = FirebaseMessaging.instance;

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  logger.i("Handling a background message: ${message.messageId}");
  // If you need to do work here, you'll need to initialize other services
  // like Firebase.initializeApp()
}

Future<void> init() async {
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    logger.i('Got a message whilst in the foreground!');
    logger.i('Message data: ${message.data}');

    if (message.notification != null) {
      logger.i(
        'Message also contained a notification: ${message.notification}',
      );
    }
  });
}

Future<void> requestPermissionAndRegisterToken() async {
  final appState = await AppState.load();
  if (appState.session == null) {
    logger.i("No session, skipping FCM token registration.");
    return;
  }

  logger.i("Requesting notification permissions...");
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    logger.i('User granted permission. Registering FCM token.');
    await updateSessionFCMToken();
    _setupTokenRefreshListener();
  } else {
    logger.i('User declined or has not accepted permission.');
  }
}

Future<void> updateSessionFCMToken() async {
  final appState = await AppState.load();
  try {
    final fcmToken = await messaging.getToken();
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
  messaging.onTokenRefresh
      .listen((fcmToken) async {
        final appState = await AppState.load();
        logger.i("FCM token refreshed: $fcmToken");
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
