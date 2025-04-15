import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './classrooms.dart';
import './dashboard.dart';
import './schedule.dart';
import '../../../backend/sessions.dart';
import '../../welcome.dart';
import '../../settings/student/home.dart';
import '../../../backend/models/session.dart';
import '../../../backend/models/user.dart';



class StudentBaseLayout extends StatelessWidget {
  final Widget body;
  final String title;
  final User student;
  final Session session;
  final int currentIndex;

  const StudentBaseLayout({
    super.key,
    required this.body,
    required this.title,
    required this.student,
    required this.session,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StudentAppBar(title, session, student),
      drawer: ,
      endDrawer: ,
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: 'Classrooms',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => StudentDashboardPage(
                        session: session,
                        student: student,
                      ),
                ),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => StudentSchedulePage(
                        session: session,
                        student: student,
                      ),
                ),
              );
              break;
            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => StudentClassroomsPage(
                        session: session,
                        student: student,
                      ),
                ),
              );
              break;
          }
        },
      ),
    );
  }
}
