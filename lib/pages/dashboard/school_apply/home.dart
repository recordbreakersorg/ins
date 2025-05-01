import 'package:flutter/material.dart';
import 'package:ins/pages/dashboard/school_apply/manager.dart';
import '../../../backend/models.dart' as models;
import '../../../loadingpage.dart';
import './instructions.dart';
import '../../../analytics.dart' as analytics;

void launchApplicationForm(
  BuildContext context,
  models.School school,
  models.Session session,
  models.User user,
  models.SchoolApplicationForm form,
) async {
  analytics.schoolApply(school.school_name);
  Navigator.push(
    context,
    MaterialPageRoute(
      builder:
          (context) => Scaffold(
            body: LoadingPage(
              messages: ["Loading...", "Getting form...", "Please wait..."],
            ),
          ),
    ),
  );
  final state = await AssistantState.loadOrCreate(form);
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
