import 'package:flutter/material.dart';
import '../../../backend/models/session.dart';
import './base.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../backend/models/user.dart';

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
      currentIndex: 1,
      body: Center(
        child: Column(
          children: [
            Icon(
              Icons.cancel_presentation,
              size: 120,
              color: Color.fromARGB(100, 10, 10, 10),
            ),
            SizedBox(height: 24),
            Text(
              'You cannot access this, Sorry.',
              style: GoogleFonts.lato(
                fontSize: 28,
                color: Color.fromARGB(100, 10, 10, 10),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              'We are sorry to tell you this but you cannot access this feature for your school did not apply for this. Please contact your administrators.',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontSize: 16,
                color: Color.fromARGB(100, 10, 10, 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
