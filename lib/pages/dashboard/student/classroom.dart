import 'package:flutter/material.dart';
import '../../../backend/models.dart';

class StudentClassroomDashboardPage extends StatelessWidget {
  final Classroom classroom;
  final User student;
  final Session session;

  const StudentClassroomDashboardPage({
    super.key,
    required this.classroom,
    required this.student,
    required this.session,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(classroom.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Card.filled(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          classroom.profile.getPath(),
                          width: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      classroom.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Card.outlined(
                child: Column(
                  children: [
                    Text("Classrooms"),
                    VerticalDivider(
                      color: Theme.of(context).colorScheme.outline,
                      thickness: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
