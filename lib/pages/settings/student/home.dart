import 'package:flutter/material.dart';
import './base.dart';
import '../../../backend/models.dart';
import './profile.dart';

class StudentsSettingsHome extends StatelessWidget {
  final Session session;
  final User student;
  const StudentsSettingsHome({
    super.key,
    required this.session,
    required this.student,
  });
  @override
  Widget build(BuildContext context) {
    return StudentSettingsBaseLayout(
      title: "Settings",
      student: student,
      session: session,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('General'),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.person_3),
            title: Text('Profile'),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => StudentSettingsProfile(
                          session: session,
                          student: student,
                        ),
                  ),
                ),
          ),
          ListTile(
            leading: Icon(Icons.group_work),
            title: Text('Sessions'),
            onTap: null,
          ),
        ],
      ),
    );
  }
}
