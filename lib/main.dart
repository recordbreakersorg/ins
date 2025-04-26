import 'package:firebase_core/firebase_core.dart';
import 'package:ins/firebase_options.dart';

import 'app.dart';
import 'package:flutter/material.dart';
import './analytics.dart' as analytics;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  analytics.intializeAnalytics();
  runApp(const InS());
}
