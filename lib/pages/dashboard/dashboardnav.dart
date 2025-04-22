import 'package:flutter/material.dart';
import '../../backend/models.dart';
import './dashboard.dart';
import './classrooms.dart';
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
    showSelectedLabels: false,
    showUnselectedLabels: false,
    selectedItemColor: Theme.of(context).primaryColor,
    unselectedItemColor: Colors.grey,
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
      BottomNavigationBarItem(
        icon: Icon(Icons.calendar_month),
        label: 'Schedule',
      ),
      BottomNavigationBarItem(icon: Icon(Icons.class_), label: 'Classrooms'),
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
