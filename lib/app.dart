import 'package:flutter/material.dart';
import 'package:ins/theme.dart';
import 'package:ins/pages/home.dart' as home;
import 'package:flutter_localizations/flutter_localizations.dart';

class ISApp extends StatelessWidget {
  const ISApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (_, _) {
        return MaterialApp(
          title: 'IS',
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('en'), Locale('fr')],
          theme: themeManager.getTheme(),
          home: home.getPage(),
        );
      },
    );
  }
}
