import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart'; // For fade-in

import '../../backend/models.dart' as models;
import './school_explore.dart';

import './base.dart';
import './errorpage.dart';

class DashboardSchoolsPage extends DashboardBase {
  const DashboardSchoolsPage({
    super.key,
    super.navIndex = 2,
    super.title = "Your schools",
    required super.session,
    required super.user,
  });

  @override
  Widget buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder<List<models.School>>(
                future: user.getSchools(session),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return ErrorPage(
                      title: "Error",
                      description: "Unable to load schools ${snapshot.error}",
                    );
                  } else if (!snapshot.hasData) {
                    return CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    );
                  } else if (snapshot.data!.isEmpty) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 30,
                        ),
                        child: Column(
                          children: [
                            Text(
                              "No schools",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "You are a member of no school yet",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    final schools = snapshot.data!;
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          // Changed to Column for list layout
                          children:
                              schools.map((school) {
                                return SchoolListCard(
                                  school: school,
                                ); // Using the new SchoolListCard
                              }).toList(),
                        ),
                      ),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Center(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.purple.shade300, Colors.amber.shade300],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => SchoolExplorePage(
                                  session: session,
                                  user: user,
                                ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        "explore",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SchoolListCard extends StatefulWidget {
  final models.School school;

  const SchoolListCard({super.key, required this.school});

  @override
  _SchoolListCardState createState() => _SchoolListCardState();
}

class _SchoolListCardState extends State<SchoolListCard> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to SchoolExplore page
      },
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
                    image: NetworkImage(widget.school.profile.getPath()),
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
                          image: widget.school.profile.getPath(),
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
                      widget.school.info.name,
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
                      "@${widget.school.school_name}",
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
