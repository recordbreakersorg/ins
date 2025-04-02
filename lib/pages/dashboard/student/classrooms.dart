import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../backend/models.dart';
import './base.dart';
import './classroom.dart';

class StudentClassroomsPage extends StatelessWidget {
  final Session session;
  final User student;

  const StudentClassroomsPage({
    super.key,
    required this.session,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return StudentBaseLayout(
      title: 'Classrooms',
      student: student,
      session: session,
      currentIndex: 4,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              FutureBuilder(
                future: session.getClassrooms(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final classrooms = snapshot.data!;
                  return classrooms.isEmpty
                      ? Card(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                "No classrooms",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Container(height: 10),
                              Text(
                                "We could not find a classroom you were a member. If you are member of one please check your internet connection. If the problem persists contact your administrators.",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      )
                      : Column(
                        children:
                            classrooms.map((classroom) {
                              return StudentClassroomCard(
                                student: student,
                                classroom: classroom,
                                session: session,
                              );
                            }).toList(),
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentClassroomCard extends StatelessWidget {
  final Session session;
  final User student;
  final Classroom classroom;
  const StudentClassroomCard({
    super.key,
    required this.session,
    required this.student,
    required this.classroom,
  });
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: session.getUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final user = snapshot.data!;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => StudentClassroomDashboardPage(
                      session: session,
                      student: user,
                      classroom: classroom,
                    ),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(45),
                        child: Image.network(
                          classroom.profile.getPath(),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(height: 20),
                            Text(
                              classroom.name,
                              style: GoogleFonts.lato(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ).copyWith(
                                color: const Color.fromRGBO(55, 71, 79, 1),
                              ),
                            ),
                            Container(height: 5),
                            Text(
                              classroom.role,
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ).copyWith(
                                color: const Color.fromRGBO(158, 158, 158, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
