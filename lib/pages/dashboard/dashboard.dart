import 'package:flutter/material.dart';
import 'package:ins/pages/dashboard/profile.dart';
import './feeds.dart';
import './base.dart';
import '../../backend/models.dart';

class DashboardPage extends DashboardBase {
  const DashboardPage({
    super.key,
    super.navIndex = 0,
    super.title = "Dashboard",
    required super.session,
    required super.user,
  });
  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: Column(
        children: [
          NotificationFeedView(
            title: "Paul sent an announcement",
            description:
                "Just making sure you do not forget the discom on Saturday.",
            image: profileAvatar(
              const Profile(pid: "paul", register: "users", ext: "jpg"),
              30,
            ),
            time: "12:00",
          ),
        ],
      ),
    );
  }
}
