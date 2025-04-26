import 'package:flutter/material.dart';
import '../../backend/models.dart' as models;
import 'package:google_fonts/google_fonts.dart';
import './school_profile.dart';
import '../../analytics.dart' as analytics;

class SchoolExplorePage extends StatelessWidget {
  final models.User user;
  final models.Session session;

  const SchoolExplorePage({
    super.key,
    required this.user,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    analytics.screen("Explore Schools");
    return Scaffold(
      appBar: AppBar(title: const Text('Explore Schools'), elevation: 0),
      body: FutureBuilder<List<models.School>>(
        future: models.School.getSchools(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return _buildSchoolList(context, snapshot.data ?? []);
        },
      ),
    );
  }

  Widget _buildSchoolList(BuildContext context, List<models.School> schools) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: schools.length,
      itemBuilder: (context, index) {
        final school = schools[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: SchoolThumbnailCard(
            school: school,
            onTap: () => _navigateToProfile(context, school),
          ),
        );
      },
    );
  }

  void _navigateToProfile(BuildContext context, models.School school) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                SchoolProfilePage(school: school, session: session, user: user),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.easeInOut;
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve,
          );
          return FadeTransition(opacity: curvedAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}

class SchoolThumbnailCard extends StatelessWidget {
  final models.School school;
  final VoidCallback? onTap;
  final double rating = 4.4;

  const SchoolThumbnailCard({super.key, required this.school, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: onTap,
          child: Container(
            constraints: BoxConstraints(
              minHeight: 160,
              maxHeight: MediaQuery.of(context).size.height * 0.25,
            ),
            child: Stack(
              children: [
                _buildBackgroundImage(),
                _buildGradientOverlay(),
                _buildContent(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Hero(
      tag: 'school-bg-${school.id}',
      child: Image.network(
        school.profile.getPath(),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value:
                  loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
            ),
          );
        },
        errorBuilder:
            (context, error, stackTrace) => Container(
              color: Colors.grey[300],
              child: const Center(child: Icon(Icons.error_outline)),
            ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.1),
            Colors.black.withOpacity(0.6),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'school-logo-${school.id}',
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 56,
                    maxHeight: 56,
                  ),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(school.profile.getPath()),
                  ),
                ),
              ),
              _buildRatingBadge(context),
            ],
          ),
          _buildSchoolInfo(),
        ],
      ),
    );
  }

  Widget _buildRatingBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      constraints: const BoxConstraints(maxHeight: 32),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 18),
          const SizedBox(width: 6),
          Text(
            rating.toStringAsFixed(1),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchoolInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          school.info.name,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          '@${school.school_name}',
          style: GoogleFonts.poppins(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
