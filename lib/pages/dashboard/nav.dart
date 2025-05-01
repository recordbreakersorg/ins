import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ins/profile.dart';
import '../../backend/sessions.dart';
import './dashboard.dart';
import '../../backend/models.dart' as models;
import '../welcome.dart';
import 'package:ins/theme.dart';

Widget dashboardNav(
  BuildContext context,
  models.Session session,
  models.User user,
) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(child: Container()),
        ListTile(
          leading: Icon(Icons.dashboard),
          title: Text("Dashboard"),
          onTap:
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => DashboardPage(session: session, user: user),
                ),
              ),
        ),
        ListTile(
          leading: Icon(Icons.book),
          title: Text("Classrooms"),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.calendar_today),
          title: Text("Schedule"),
          onTap: () {},
        ),
      ],
    ),
  );
}

Widget dashboardAccountNav(
  BuildContext context,
  models.Session session,
  models.User user,
) {
  return Drawer(
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
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text("Sign Out"),
          onTap: () {
            sessionManager.clearSession();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => WelcomePage(title: "Welcome back"),
              ),
              (route) => false,
            );
          },
        ),
      ],
    ),
  );
}
