import 'package:flutter/material.dart';
import 'package:ins/app.dart';
import 'package:ins/theme.dart' as theme;
import 'package:ins/locale.dart' as locale;

void main() {
  print("started running");
  WidgetsFlutterBinding.ensureInitialized();
  theme.init();
  locale.init();
  // nothing
  runApp(const ISApp());
}
