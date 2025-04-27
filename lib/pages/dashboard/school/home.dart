import 'package:flutter/material.dart';
import '../../../backend/models.dart' as models;
import './student/home.dart';

Future<void> launchSchoolDashboard(
  BuildContext context,
  models.School school,
  models.User user,
  models.Session session,
) async {
  final member = await school.getMember(session);
  switch (member.role) {
    case models.UserRole.student:
      launchStudentSchoolView(
        context: context,
        school: school,
        user: user,
        member: member,
        session: session,
      );
      break;
    case models.UserRole.teacher:
      //launchTeacherDashboard(context, school, user, member);
      break;
    case models.UserRole.parent:
      //launchParentDashboard(context, school, user, member);
      break;
    case models.UserRole.admin:
      //launchAdminDashboard(context, school, user, member);
      break;
    default:
      // Handle unknown role
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Unknown role: ${member.role}"),
          duration: const Duration(seconds: 2),
        ),
      );
      break;
  }
}
