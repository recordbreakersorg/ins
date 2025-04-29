import 'package:flutter/material.dart';
import '../../backend/models.dart';
import './dashboard.dart';
import './classrooms.dart';
import './schools.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Widget dashboardBottomNav(
  BuildContext context,
  Session session,
  User user,
  int index,
) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    currentIndex: index,
    // showSelectedLabels: false,
    // showUnselectedLabels: false,
    selectedItemColor: Theme.of(context).colorScheme.primary,
    unselectedItemColor: Colors.grey.shade600,
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: AppLocalizations.of(context)!.home),
      BottomNavigationBarItem(icon: Icon(Icons.class_), label: AppLocalizations.of(context)!.classrooms),
      BottomNavigationBarItem(
        icon: Icon(Icons.school),
        label: AppLocalizations.of(context)!.schools,
      ),
    ],
    onTap: (index) {
      switch (index) {
        case 0:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardPage(session: session, user: user),
            ),
          );
          break;
        case 1:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      DashboardClassroomsPage(session: session, user: user),
            ),
          );
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      DashboardSchoolsPage(session: session, user: user),
            ),
          );
          break;
      }
    },
  );
}
