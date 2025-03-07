import 'package:flutter/material.dart';
import 'pages/welcome.dart';
import 'theme.dart';

class InS extends StatelessWidget {
  const InS({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intranet of Schools',
      theme: makeTheme(),
      home: const WelcomePage(title: 'Welcome to the Intranet of Schools'),
    );
  }
}

