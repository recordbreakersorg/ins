import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart'; // For fade-in
import 'dart:ui'; // For ImageFilter
import '../../backend/models.dart' as models; // Import your models

class SchoolProfilePage extends StatelessWidget {
  final models.School school;
  final models.User user;
  final models.Session session;
  //final double rating; // Remove hardcoded rating, use school data if available
  //final int numberOfMembers; // Remove hardcoded member count, use school data if available
  final String description =
      "Welcome to our vibrant school community! We are dedicated to fostering a supportive and challenging learning environment where students can thrive academically, socially, and personally.  Explore our diverse programs, passionate faculty, and state-of-the-art facilities. Join us in shaping a bright future!"; // Example Description

  const SchoolProfilePage({
    super.key,
    required this.school,
    required this.session,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    //double rating = 4.5;
    //int numberOfMembers = 120;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image with Blur
          Positioned.fill(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: school.profile.getPath(),
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
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: Colors.black.withOpacity(0.5), // Gradient Overlay
              ),
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Button
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(height: 20),
                    // School Name and Logo
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(
                            school.profile.getPath(),
                          ),
                          onBackgroundImageError: (exception, stackTrace) {
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey[300],
                              child: const Icon(Icons.error_outline),
                            );
                          },
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            school.info.name,
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black87,
                                  blurRadius: 8,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Rating and Members (if available)
                    if (school.toJson().containsKey('rating') &&
                        school.toJson().containsKey('numberOfMembers'))
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            (school.toJson()['rating'] ?? 0.0).toStringAsFixed(
                              1,
                            ),
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.people,
                            color: Colors.cyan,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            (school.toJson()['numberOfMembers'] ?? 0)
                                .toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 24),
                    // Description
                    Text(
                      description,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        height: 1.5,
                        shadows: [
                          Shadow(
                            color: Colors.black87,
                            blurRadius: 6,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Apply Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle Apply Now
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          "Apply Now",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Additional Information (Example: Location)
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.white.withOpacity(0.9),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.blueAccent,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Location: ${school.toJson()['location'] ?? 'N/A'}", // Access location from school data
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Add more sections as needed (e.g., programs, events)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
