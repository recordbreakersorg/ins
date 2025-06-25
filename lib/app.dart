import 'package:flutter/material.dart';
import 'package:ins/theme.dart';
import 'package:ins/pages/home.dart' as home;
import 'package:ins/l10n/app_localizations.dart';
//import 'package:ins/locale.dart' as locale;

class ISApp extends StatelessWidget {
  const ISApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (_, _) {
        return MaterialApp(
          title: 'IS',
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: themeManager.getTheme(),
          home: home.getPage(),
        );
      },
    );
  }
}
