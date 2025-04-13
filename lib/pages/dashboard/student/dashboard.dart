import 'package:flutter/material.dart';
import '../../../backend/model.dart';
import './base.dart';
import './feeds.dart';

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
      title: 'Dashboard',
      student: student,
      session: session,
      currentIndex: 0,
      body: Center(
        child: Column(
          children: [
            NotificationFeedView(
              title: "Paul sent an announcement",
              description:
                  "Just making sure you do not forget the discom on Saturday.",
              imageWebPath: "http://localhost:8080/profiles/users/paul.jpg",
              time: "12:00",
            ),
          ],
        ),
      ),
    );
  }
}
