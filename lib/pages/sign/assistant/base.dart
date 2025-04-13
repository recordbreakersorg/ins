import 'package:flutter/material.dart';

class AssistantBasePage extends StatelessWidget {
  final Widget body;
  final Widget title;
  const AssistantBasePage({super.key, required this.body, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(), title: title),
      body: body,
    );
  }
}
