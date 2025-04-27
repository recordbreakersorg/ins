import 'package:flutter/material.dart';
import 'package:ins/offline.dart';
import 'package:ins/profile.dart';
import '../../backend/models/session.dart';
import '../../backend/models/user.dart';

AppBar dashboardAppBar(String title, Session session, User student) {
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
    title: appBarTitle(title),
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
  return bar;
}
