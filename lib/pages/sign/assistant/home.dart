import 'package:flutter/material.dart';
import './manager.dart';
import './terms.dart';
import '../../../analytics.dart' as analytics;

Future<void> launchAssistant(BuildContext context) async {
  analytics.screen("signup assistant");
  final assistantState = await SignupAssistantState.loadOrCreate();

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TermsPage(assistantState: assistantState),
    ),
  );
}

Future<Widget> assistant(BuildContext context) async {
  final assistantState = await SignupAssistantState.loadOrCreate();
  return TermsPage(assistantState: assistantState);
}
