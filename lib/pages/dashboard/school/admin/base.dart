import 'package:flutter/material.dart';
import 'package:ins/offline.dart';
import 'package:ins/backend/models.dart' as models;
import 'package:ins/pages/dashboard/dashboard.dart' as dashboard;
import 'package:ins/analytics.dart' as analytics;
import 'package:ins/profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ins/theme.dart';
import './dashboard.dart';
import './users.dart';

class AdminSchoolViewBase extends StatelessWidget {
  final models.Session session;
  final models.User user;
  final models.School school;
  final models.SchoolMember member;
  final int index;
  const AdminSchoolViewBase({
    super.key,
    required this.session,
    required this.user,
    required this.member,
    required this.school,
    required this.index,
  });

  Widget buildContent(BuildContext context) {
    return Text("Content");
  }

  String getTitle(BuildContext context) {
    return "Dashboard";
  }

  @override
  Widget build(BuildContext context) {
    analytics.screen("admin_school_view");
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: appBarTitle(getTitle(context)),
        actions: [
          Builder(
            builder:
                (context) => GestureDetector(
                  onTap: () => Scaffold.of(context).openEndDrawer(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: profileAvatar(
                      profile: user.profile,
                      radius: 20,
                      name: user.info.name,
                    ),
                  ),
                ),
          ),
        ],
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
                  profileAvatar(
                    profile: user.profile,
                    radius: 50,
                    name: user.info.name,
                  ),
                  SizedBox(width: 10),
                  Column(
                    children: [
                      SizedBox(height: 30),
                      Text(
                        user.username,
                        style: GoogleFonts.lato(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 30),
                      ThemeSwitcherWidget(),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Exit"),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => dashboard.DashboardPage(
                          title: "Welcome back",
                          session: session,
                          user: user,
                        ),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: buildContent(context),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey.shade600,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Users"),
          BottomNavigationBarItem(
            icon: Icon(Icons.class_),
            label: "Classrooms",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: "School Applications",
          ),
        ],
        currentIndex: index,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => AdminSchoolDashboardPage(
                        session: session,
                        user: user,
                        school: school,
                        member: member,
                      ),
                ),
              );
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => AdminSchoolUsersPage(
                        session: session,
                        user: user,
                        school: school,
                        member: member,
                      ),
                ),
              );
              break;
            case 2:
              break;
            case 3:
              break;
          }
        },
      ),
    );
  }
}
