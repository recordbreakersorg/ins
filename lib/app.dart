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
      theme: makeTheme(),
      home: FutureBuilder(
        future: sessionManager.loadSession(),
        builder: (context, snapshot) {
          return WelcomePage(title: 'Welcome to the Intranet of Schools');
        },
      ),
    );
  }
}
