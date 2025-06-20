import 'package:flutter/material.dart';
import 'package:ins/theme.dart';
import 'package:ins/pages/home.dart';

class ISApp extends StatelessWidget {
  const ISApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IS',
      theme: themeManager.getTheme(),
      home: getPage(),
    );
  }
}
