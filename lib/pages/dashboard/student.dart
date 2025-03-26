import 'package:flutter/material.dart';
import '../../backend/models.dart';
import 'package:google_fonts/google_fonts.dart';

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
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: Text(
          title,
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        actions: [
          Builder(
            builder:
                (context) => GestureDetector(
                  onTap: () => Scaffold.of(context).openEndDrawer(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(student.profile.getPath()),
                      radius: 16,
                    ),
                  ),
                ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Courses'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Schedule'),
              onTap: () => Navigator.pop(context),
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
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.announcement), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.class_), label: ''),
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
            case 4:
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

class StudentDashboardPage extends StatelessWidget {
  final User student;
  final Session session;

  const StudentDashboardPage({
    super.key,
    required this.student,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return StudentBaseLayout(
      title: 'Dashboards are here',
      student: student,
      session: session,
      currentIndex: 0,
      body: Center(child: Card(child: Text("hello"))),
    );
  }
}

class StudentClassroomsPage extends StatelessWidget {
  final Session session;
  final User student;

  const StudentClassroomsPage({
    super.key,
    required this.session,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return StudentBaseLayout(
      title: 'Classrooms',
      student: student,
      session: session,
      currentIndex: 4,
      body: Center(child: Text('Classrooms Content')),
    );
  }
}

class StudentSchedulePage extends StatelessWidget {
  final Session session;
  final User student;

  const StudentSchedulePage({
    super.key,
    required this.session,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return StudentBaseLayout(
      title: 'Schedule',
      student: student,
      session: session,
      currentIndex: 2,
      body: Center(child: Text('Schedule Content')),
    );
  }
}
