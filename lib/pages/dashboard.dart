import 'package:flutter/material.dart';
import '../backend/models.dart';

class StudentSignupPage extends StatelessWidget {
  final User user;
  final School school;
  const StudentSignupPage({
    super.key,
    required this.user,
    required this.school,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: Text('Dashboard'),
        actions: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.profile.getPath()),
            radius: 16,
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }
}
