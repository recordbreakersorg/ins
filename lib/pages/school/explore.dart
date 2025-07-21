import 'package:flutter/material.dart';
import 'package:ins/animations/page/fade.dart';
import 'package:ins/models.dart' as models;

import 'package:ins/stuff.dart' as stuff;
import 'package:google_fonts/google_fonts.dart';
import 'package:ins/appstate.dart';
import 'package:ins/widgets/loading.dart';
import 'school_profile.dart';
import 'package:ins/l10n/app_localizations.dart';

class SchoolExplorePage extends StatefulWidget {
  final AppState appState;

  const SchoolExplorePage({super.key, required this.appState});

  @override
  State<SchoolExplorePage> createState() => _SchoolExplorePageState();
}

class _SchoolExplorePageState extends State<SchoolExplorePage> {
  int searchOffset = 0;
  int searchLimit = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.exploreSchools),
        elevation: 0,
      ),
      body: FutureBuilder<List<models.School>>(
        future: models.School.getAllSchools(
          widget.appState.session,
          searchOffset,
          searchLimit,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingWidget();
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.error, size: 200, color: Colors.red),
                      SizedBox(height: 30),
                      Text(
                        "${snapshot.error}",
                        style: Theme.of(
                          context,
                        ).textTheme.displayLarge?.copyWith(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          final schools = snapshot.data ?? [];
          return schools.isNotEmpty
              ? _buildSchoolList(context, snapshot.data ?? [])
              : Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.question_mark,
                            size: 200,
                            color: Theme.of(
                              context,
                            ).textTheme.displayLarge?.color,
                          ),
                          SizedBox(height: 30),
                          Text(
                            AppLocalizations.of(context)!.noSchoolFound,
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget _buildSchoolList(BuildContext context, List<models.School> schools) {
    return SizedBox(
      width: 600,

      child: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        // The total number of items in your list.
        itemCount: schools.length,

        // This is the magic part that makes the grid responsive.
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          // 1. maxCrossAxisExtent:
          // This tells the grid to create columns that are at most 600 pixels wide.
          // It will fit as many columns as it can. For example:
          // - On a 400px wide phone -> 1 column
          // - On an 800px wide tablet -> 2 columns (each ~400px wide)
          // - On a 1300px wide screen -> 2 columns (each ~650px wide, but our card is capped at 600)
          maxCrossAxisExtent: 600.0,

          // 2. childAspectRatio:
          // Since our card is designed to be 16:9, we must specify this.
          // It ensures the height of the grid cell is correct relative to its width.
          childAspectRatio: 16 / 9,

          // 3. Spacing:
          // These properties add space between the cards, both horizontally and vertically.
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
        ),

        // The itemBuilder is the same as in ListView.builder.
        // We no longer need the Padding widget because the spacing is handled by the gridDelegate.
        itemBuilder: (context, index) {
          final school = schools[index];
          return SchoolThumbnailCard(
            school: school,
            onTap: () => _navigateToProfile(context, school),
          );
        },
      ),
    );
  }

  void _navigateToProfile(BuildContext context, models.School school) {
    Navigator.of(context).push(
      FadePageRoute(
        builder: (context) =>
            SchoolProfilePage(appState: widget.appState, school: school),
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
        stuff.fileUrl(school.profileImage ?? 1),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
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
          colors: [Colors.black.withAlpha(20), Colors.black.withAlpha(150)],
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
                    backgroundColor: Colors.transparent,
                    child: null,
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
        color: Colors.black.withAlpha(180),
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
          school.fullname,
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
          '@${school.schoolname}',
          style: GoogleFonts.poppins(
            color: Colors.white.withAlpha(200),
            fontSize: 12,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
