import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'base.dart';

class ParentSchoolDashboardPage extends ParentSchoolViewBase {
  const ParentSchoolDashboardPage({
    super.key,
    required super.school,
    required super.member,
    required super.session,
    required super.user,
    super.index = 0,
  });
  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Hero(
                          tag: school.profile.getPath(),
                          child: Image.network(
                            school.profile.getPath(),
                            width: 200,
                            height: 200,
                          ),
                        ),
                        SizedBox(width: 20),
                        Hero(
                          tag: "school-name-n-school_name-${school.id}",
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                school.info.name,
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
                                "@${school.school_name}",
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
                SizedBox(height: 20),
                Text(
                  "Good Day ${user.info.name}, what would you like to do?",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
