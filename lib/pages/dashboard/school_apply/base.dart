import 'package:flutter/material.dart';
import 'package:ins/backend/models.dart' as models;
import 'package:ins/offline.dart';
import './manager.dart';

class AssistantBasePage extends StatelessWidget {
  final String title;
  final models.Session session;
  final models.User user;
  final models.School school;
  final AssistantState assistantState;
  final models.SchoolApplicationForm form;
  const AssistantBasePage({
    super.key,
    required this.title,
    required this.session,
    required this.user,
    required this.school,
    required this.assistantState,
    required this.form,
  });
  Widget buildContent(BuildContext context) {
    throw UnimplementedError(
      'buildContent() must be implemented in subclasses',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(), title: appBarTitle(title)),
      body: buildContent(context),
    );
  }
}
