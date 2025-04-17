import 'package:flutter/material.dart';
import 'package:ins/pages/dashboard/profile.dart';
import '../../backend/models/session.dart';
import '../../backend/models/user.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar dashboardAppBar(String title, Session session, User student) {
  print("building appbar");
  final bar = AppBar(
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
    title: Text(title, style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
    actions: [
      Builder(
        builder:
            (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openEndDrawer(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: profileAvatar(student.profile, 20),
              ),
            ),
      ),
    ],
  );
  print("built bar");
  return bar;
}
