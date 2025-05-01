import 'package:flutter/material.dart';
import '../../../backend/models.dart' as models;
import './student/home.dart';
import './admin/home.dart';

Future<void> launchSchoolDashboard(
  BuildContext context,
  models.School school,
  models.User user,
  models.Session session,
) async {
  final member = await school.getMember(session);
  print("Member: $member, role: ${member.role}");
  switch (member.role) {
    case models.SchoolMemberRole.student:
      launchStudentSchoolView(
        context: context,
        school: school,
        user: user,
        member: member,
        session: session,
      );
      break;
    case models.SchoolMemberRole.teacher:
      //launchTeacherDashboard(context, school, user, member);
      break;
    case models.SchoolMemberRole.parent:
      //launchParentDashboard(context, school, user, member);
      break;
    case models.SchoolMemberRole.admin:
      launchAdminSchoolView(
        context: context,
        school: school,
        user: user,
        member: member,
        session: session,
      );
      //launchAdminDashboard(context, school, user, member);
      break;
  }
}
