import 'package:flutter/material.dart';
import 'package:ins/pages/dashboard/profile.dart';
import '../../backend/models/session.dart';
import '../../backend/models/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.lato(fontWeight: FontWeight.bold)),
        StreamBuilder<ConnectivityResult>(
          stream: Connectivity().onConnectivityChanged.map(
            (results) =>
                results.isNotEmpty ? results.first : ConnectivityResult.none,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == ConnectivityResult.none) {
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Offline',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      ],
    ),
    actions: [
      Builder(
        builder:
            (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openEndDrawer(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: profileAvatar(
                  profile: student.profile,
                  radius: 20,
                  name: student.info.name,
                ),
              ),
            ),
      ),
    ],
  );
  print("built bar");
  return bar;
}
