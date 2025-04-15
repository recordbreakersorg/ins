import 'package:flutter/material.dart';
import 'pages/welcome.dart';
import 'theme.dart';
import './backend/sessions.dart';

class InS extends StatelessWidget {
  const InS({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intranet of Schools',
      darkTheme: themeManager.darkTheme,
      theme: themeManager.lightTheme,
      themeMode: themeManager.themeMode,
      home: FutureBuilder(
        future: sessionManager.loadSession(),
        builder: (context, snapshot) {
          print("loaded session ${sessionManager.session}");
          return WelcomePage(title: 'Welcome to the Intranet of Schools');
        },
      ),
    );
  }
}
