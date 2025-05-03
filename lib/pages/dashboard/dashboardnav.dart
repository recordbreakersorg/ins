import 'package:flutter/material.dart';
import '../../backend/models.dart';
import './dashboard.dart';
import './schools.dart';

Widget dashboardBottomNav(
  BuildContext context,
  Session session,
  User user,
  int index,
) {
  return BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
    currentIndex: index,
    selectedItemColor: Theme.of(context).colorScheme.primary,
    unselectedItemColor: Colors.grey.shade600,
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Home"),
      BottomNavigationBarItem(icon: Icon(Icons.school), label: "Schools"),
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
                      DashboardSchoolsPage(session: session, user: user),
            ),
          );
          break;
      }
    },
  );
}
