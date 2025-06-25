import 'package:flutter/material.dart';
import 'package:ins/app.dart';
import 'package:ins/theme.dart' as theme;
import 'package:ins/locale.dart' as locale;

void main() async {
  try {
    await theme.init();
    await locale.init();
  } catch (e) {
    // nothing
  }
  runApp(const ISApp());
}
