import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart'; // For fade-in

import './base.dart';
import '../../errorpage.dart';
import '../../backend/models.dart' as models;

class DashboardClassroomsPage extends DashboardBase {
  const DashboardClassroomsPage({
    super.key,
    super.navIndex = 1,
    super.title = "Your classrooms",
    required super.session,
    required super.user,
  });
  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: user.getClassrooms(session),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorPage(
              title: "Error",
              description: "Unable to load classrooms ${snapshot.error}",
            );
          } else if (!snapshot.hasData) {
            return CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            );
          } else if (snapshot.data!.isEmpty) {
            return Card(
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
                      "You are not a member of any classroom yet",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    FutureBuilder(
                      future: user.getClassrooms(session),
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
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.titleLarge,
                                    ),
                                    Container(height: 10),
                                    Text(
                                      "You are not a member of any classroom yet",
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            )
                            : Column(
                              children:
                                  classrooms.map((classroom) {
                                    return StudentClassroomCard(
                                      student: user,
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
            );
          }
        },
      ),
    );
  }
}

class StudentClassroomCard extends StatelessWidget {
  final models.Session session;
  final models.User student;
  final models.Classroom classroom;
  const StudentClassroomCard({
    super.key,
    required this.session,
    required this.student,
    required this.classroom,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Container(
                width: 120, // Increased width
                height: 120, // Increased height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(classroom.profile.getPath()),
                    fit:
                        BoxFit
                            .cover, // Ensure image covers the entire container
                  ),
                  color: Colors.transparent,
                  backgroundBlendMode: BlendMode.srcOver,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      color: Colors.transparent,
                      child: Center(
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: classroom.profile.getPath(),
                          width: 70, // Increased width
                          height: 70, // increased height
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey.shade300,
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      classroom.info.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Display school.school_name as preformatted text
                    Text(
                      "@${classroom.classroomName}",
                      style: GoogleFonts.sourceCodePro(
                        // Use a monospace font
                        fontSize: 12, // Smaller font size
                        color:
                            Colors
                                .grey[700], // Darker grey for preformatted text
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
