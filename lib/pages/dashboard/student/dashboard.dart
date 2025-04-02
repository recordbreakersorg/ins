import 'package:flutter/material.dart';
import '../../../backend/models.dart';
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
              title: "Ama made an announcement",
              description:
                  "Hello USS@Banana academy, just make you notice: *The school will be closed on Monday* due to the weather so please *endeavor to do your assignments before wednesday*, **NO EXCUSE**",
              imageWebPath:
                  "http://localhost:8080/profiles/users/67ccaf608c35a17d20904b81.png",
              time: "12:00",
            ),
          ],
        ),
      ),
    );
  }
}