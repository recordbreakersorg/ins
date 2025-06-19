import 'package:firebase_core/firebase_core.dart';
import 'package:ins/firebase_options.dart';

import 'app.dart';
import 'package:flutter/material.dart';
import './analytics.dart' as analytics;
import './theme.dart';

void main() async {
  themeManager.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    analytics.intializeAnalytics();
    print("Analytics succesfully launched");
  } catch (e) {
    print("Error starting analytics, deactivating: $e");
    analytics.deactivate();
  }
  runApp(const InS());
}
