import 'package:flutter/material.dart';
import './manager.dart';
import './roleshooser.dart';

Future<void> launchAssistant(BuildContext context) async {
  final assistantState = await SignupAssistantState.loadOrCreate();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => RoleChooser(assistantState: assistantState),
    ),
  );
}

Future<Widget> assistant(BuildContext context) async {
  final assistantState = await SignupAssistantState.loadOrCreate();
  return RoleChooser(assistantState: assistantState);
}
