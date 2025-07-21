import 'package:ins/appstate.dart';
import 'package:ins/firebase_messaging.dart';
import 'package:ins/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ins/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:ins/app.dart';
import 'package:ins/theme.dart' as theme;
import 'package:ins/locale.dart' as locale;

void main() async {
  logger.i("started running");
  WidgetsFlutterBinding.ensureInitialized();
  final appState = await AppState.load();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // This now only sets up the background handler, so it's safe to call here.
    await FirebaseMessagingHandler().init();
  } catch (e) {
    logger.e("Error initializing Firebase: $e");
  }
  theme.init();
  locale.init();
  runApp(ISApp(appState: appState));
}
