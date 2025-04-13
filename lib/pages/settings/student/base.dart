import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../dashboard/student/base.dart';
import '../../dashboard/student/classrooms.dart';
import '../../dashboard/student/dashboard.dart';
import '../../dashboard/student/schedule.dart';
import '../../../backend/sessions.dart';
import '../../welcome.dart';
import '../../../backend/models/user.dart';
import '../../../backend/models/session.dart';

class StudentSettingsBaseLayout extends StatelessWidget {
  final Widget body;
  final String title;
  final User student;
  final Session session;

  const StudentSettingsBaseLayout({
    super.key,
    required this.body,
    required this.title,
    required this.student,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StudentAppBar(title, session, student),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap:
                  () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => StudentDashboardPage(
                            session: session,
                            student: student,
                          ),
                    ),
                  ),
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Classrooms'),
              onTap:
                  () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => StudentClassroomsPage(
                            session: session,
                            student: student,
                          ),
                    ),
                  ),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Schedule'),
              onTap:
                  () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => StudentSchedulePage(
                            session: session,
                            student: student,
                          ),
                    ),
                  ),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(student.profile.getPath()),
                    radius: 50,
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: [
                      SizedBox(height: 30),
                      Text(
                        student.name,
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign Out'),
              onTap: () {
                sessionManager.clearSession();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WelcomePage(title: "Good bye."),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}
