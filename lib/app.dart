import 'package:flutter/material.dart';
import 'package:ins/theme.dart';
import 'package:ins/pages/home.dart' as home;

class ISApp extends StatelessWidget {
  const ISApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (_, _) {
        return MaterialApp(
          title: 'IS',
          theme: themeManager.getTheme(),
          home: home.getPage(),
        );
      },
    );
  }
}
