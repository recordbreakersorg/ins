import 'package:flutter/material.dart';
import '../../../../backend/models.dart' as models;
import './dashboard.dart';

Future<void> launchAdminSchoolView({
  required BuildContext context,
  required models.School school,
  required models.User user,
  required models.SchoolMember member,
  required models.Session session,
}) async {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder:
          (context) => AdminSchoolDashboardPage(
            school: school,
            member: member,
            session: session,
            user: user,
          ),
    ),
  );
}
