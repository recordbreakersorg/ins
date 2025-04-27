import 'package:flutter/material.dart';
import '../../../../backend/models.dart' as models;
import '../../../../analytics.dart' as analytics;

class StudentSchoolViewBase extends StatelessWidget {
  final models.Session session;
  final models.User user;
  final models.School school;
  final models.SchoolMember member;
  const StudentSchoolViewBase({
    super.key,
    required this.session,
    required this.user,
    required this.member,
    required this.school,
  });

  Widget buildContent(BuildContext context) {
    return Text("Content");
  }

  @override
  Widget build(BuildContext context) {
    analytics.screen("student_school_view");
    return Scaffold(
      appBar: AppBar(leading: BackButton()),
      body: buildContent(context),
    );
  }
}
