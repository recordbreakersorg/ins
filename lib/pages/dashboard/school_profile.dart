import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../backend/models.dart' as models;
import './school_apply/home.dart';
import '../../analytics.dart' as analytics;

class SchoolProfilePage extends StatelessWidget {
  final models.School school;
  final models.User user;
  final models.Session session;

  const SchoolProfilePage({
    super.key,
    required this.school,
    required this.session,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    analytics.schoolProfile(school.id);
    return Scaffold(
      body: Stack(
        children: [
          _buildHeroBackground(),
          _buildScrim(),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildHeroBackground() {
    return Positioned.fill(
      child: Hero(
        tag: 'school-bg-${school.id}',
        child: Stack(
          fit: StackFit.expand,
          children: [
            FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: school.profile.getPath(),
              fit: BoxFit.cover,
              imageErrorBuilder:
                  (context, error, stackTrace) => Container(
                    color: Colors.grey.shade300,
                    child: const Center(child: Icon(Icons.error)),
                  ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                color: Colors.black.withOpacity(
                  0,
                ), // keep transparent for blur only
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrim() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.2),
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(context),
            _buildSchoolHeader(),
            _buildStatsRow(),
            _buildDescription(),
            _buildApplyButton(),
            _buildAdditionalInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSchoolHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Hero(
            tag: 'school-logo-${school.id}',
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(school.profile.getPath()),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              school.info.name,
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      child: Row(
        children: [
          _buildStatItem(Icons.star, "4.4"),
          _buildStatItem(Icons.people, "0"),
          _buildStatItem(Icons.location_city, "Somewhere"),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: MarkdownBody(
        data: school.info.description,
        styleSheet: MarkdownStyleSheet(
          p: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildApplyButton() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: FutureBuilder<bool>(
        future: school.hasApplicationForm(),
        builder: (context, snapshot) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child:
                snapshot.hasData
                    ? Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.edit_document),
                        label: const Text('Start Application'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          textStyle: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          disabledBackgroundColor: Colors.grey.shade400,
                        ),
                        onPressed:
                            snapshot.data == true
                                ? () => launchApplicationForm(
                                  context,
                                  school,
                                  session,
                                  user,
                                )
                                : null,
                      ),
                    )
                    : const CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        color: Colors.white.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [_buildInfoItem(Icons.location_on, school.info.address)],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String? text) {
    if (text == null) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade800),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
