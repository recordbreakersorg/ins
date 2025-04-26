import 'package:flutter/material.dart';
import '../../../backend/models.dart' as models;
import './admin/home.dart';
import './student/home.dart';
import './teacher/home.dart';
import './parent/home.dart';

Future<void> launchSchoolDashboard(
  BuildContext context,
  models.School school,
  models.User user,
) async {
  final member = await user.getSchoolMember(school);
  switch (member.role) {
    case models.UserRole.student:
      launchStudentDashboard(context, school, user, member);
      break;
    case models.UserRole.teacher:
      launchTeacherDashboard(context, school, user, member);
      break;
    case models.UserRole.parent:
      launchParentDashboard(context, school, user, member);
      break;
    case models.UserRole.admin:
      launchAdminDashboard(context, school, user, member);
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
