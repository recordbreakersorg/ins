import 'package:flutter/material.dart';
import '../../../../backend/models.dart' as models;
import 'dashboard.dart';

Future<void> launchParentSchoolView({
  required BuildContext context,
  required models.School school,
  required models.User user,
  required models.SchoolMember member,
  required models.Session session,
}) async {
  Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder:
          (context, animation, secondaryAnimation) => ParentSchoolDashboardPage(
            school: school,
            member: member,
            session: session,
            user: user,
          ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
              reverseCurve: Curves.easeInOut.flipped,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    ),
  );
}
