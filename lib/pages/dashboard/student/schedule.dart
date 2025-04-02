import 'package:flutter/material.dart';
import '../../../backend/models.dart';
import './base.dart';


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