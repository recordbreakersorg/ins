import 'package:flutter/material.dart';
import 'package:ins/pages/dashboard/school_apply/manager.dart';
import '../../../backend/models.dart' as models;
import '../loadingpage.dart';
import './instructions.dart';

Future<models.SchoolApplicationForm> loadApplicationForm(
  models.School school,
) async {
  await Future.delayed(const Duration(seconds: 3));
  final form = await school.getApplicationForm();
  if (form != null) {
    return form;
  } else {
    throw Exception('No application form found');
  }
}

void launchApplicationForm(
  BuildContext context,
  models.School school,
  models.Session session,
  models.User user,
) async {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder:
          (context) => Scaffold(
            body: LoadingPage(
              messages: ['Loading...', 'Getting form...', 'Please wait...'],
            ),
          ),
    ),
  );
  final form = await school.getApplicationForm();
  final state = await AssistantState.loadOrCreate(form!);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder:
          (context) => ApplicationFormInstructionsPage(
            session: session,
            user: user,
            school: school,
            assistantState: state,
            form: form,
          ),
    ),
  );
}
