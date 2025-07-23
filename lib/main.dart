import 'package:ins/appstate.dart';
import 'package:ins/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ins/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:ins/app.dart';
import 'package:ins/theme.dart' as theme;
import 'package:ins/locale.dart' as locale;
import 'package:ins/firebase_messaging.dart' as firebase_messaging;

void main() async {
  logger.i("started running");
  WidgetsFlutterBinding.ensureInitialized();
  final appState = await AppState.load();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await firebase_messaging.init();
  } catch (e) {
    logger.e("Error initializing Firebase: $e");
  }
  theme.init();
  locale.init();
  runApp(ISApp(appState: appState));
}
