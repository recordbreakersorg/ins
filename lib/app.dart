import 'package:flutter/material.dart';

class ISApp extends StatelessWidget {
  const ISApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IS',
      theme: ThemeData(),
      home: Center(child: Text("Hello RB")),
    );
  }
}
