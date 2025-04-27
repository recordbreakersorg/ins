import 'package:flutter/material.dart';
import './base.dart';

class StudentSchoolDashboardPage extends StudentSchoolViewBase {
  const StudentSchoolDashboardPage({
    super.key,
    required super.school,
    required super.member,
    required super.session,
    required super.user,
  });
  @override
  Widget buildContent(BuildContext context) {
    return Text("Student school dashboard");
  }
}
