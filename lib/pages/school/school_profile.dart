import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ins/models.dart' as models;
import 'package:ins/appstate.dart';
import 'package:ins/l10n/app_localizations.dart';

class SchoolProfilePage extends StatelessWidget {
  final models.School school;
  final AppState appState;

  const SchoolProfilePage({
    super.key,
    required this.school,
    required this.appState,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;
          return isWide
              ? _buildWideLayout(context)
              : _buildNarrowLayout(context);
        },
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context, onWideLayout: true),
                const SizedBox(height: 40),
                _buildSchoolHeader(context, onWideLayout: true),
                const SizedBox(height: 40),
                _buildDescription(context, onWideLayout: true),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.grey.shade50,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocalizations.of(context)!.atAGlance,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildStatsRow(context, onWideLayout: true),
                const Divider(height: 48, thickness: 0.5),
                _buildAdditionalInfo(context, onWideLayout: true),
                const Spacer(),
                _buildApplyButton(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200.0,
          backgroundColor: Colors.white,
          elevation: 0,
          pinned: true,
          leading: _buildAppBar(context),
          flexibleSpace: FlexibleSpaceBar(background: _buildHeroBanner()),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSchoolHeader(context),
                const SizedBox(height: 32),
                _buildStatsRow(context),
                const Divider(height: 48, thickness: 0.5),
                _buildDescription(context),
                const SizedBox(height: 32),
                _buildAdditionalInfo(context),
                const SizedBox(height: 32),
                _buildApplyButton(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo(
    BuildContext context, {
    bool onWideLayout = false,
  }) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.contactInformation,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        _buildInfoItem(Icons.location_on, school.address),
      ],
    );

    return onWideLayout
        ? content
        : Card(
            elevation: 0,
            color: Colors.grey.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(padding: const EdgeInsets.all(20), child: content),
          );
  }

  Widget _buildAppBar(BuildContext context, {bool onWideLayout = false}) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        color: onWideLayout ? Colors.black87 : Colors.black54,
      ),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    return FilledButton.icon(
      onPressed: null, // TODO: Implement application logic
      icon: const Icon(Icons.edit_document),
      label: Text(AppLocalizations.of(context)!.applyNow),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        textStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context, {bool onWideLayout = false}) {
    return MarkdownBody(
      data:
          school.description ??
          AppLocalizations.of(context)!.noDescriptionProvided,
      styleSheet: MarkdownStyleSheet(
        p: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.black87.withOpacity(0.7),
          height: 1.7,
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Hero(
      tag: 'school-bg-${school.id}',
      child: Container(
        decoration: BoxDecoration(
          image: school.logoUrl != null
              ? DecorationImage(
                  image: NetworkImage(school.logoUrl!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.2),
                    BlendMode.darken,
                  ),
                )
              : null,
          color: Colors.grey.shade200,
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String? text) {
    if (text == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade800, size: 22),
          const SizedBox(width: 16),
          Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 15))),
        ],
      ),
    );
  }

  Widget _buildSchoolHeader(BuildContext context, {bool onWideLayout = false}) {
    return Row(
      children: [
        Hero(
          tag: 'school-logo-${school.id}',
          child: CircleAvatar(
            radius: onWideLayout ? 50 : 40,
            backgroundColor: Colors.white,
            backgroundImage: school.logoUrl != null
                ? NetworkImage(school.logoUrl!)
                : null,
            child: school.logoUrl == null
                ? Text(
                    school.schoolname.isNotEmpty ? school.schoolname[0] : 'S',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                school.fullname,
                style: GoogleFonts.poppins(
                  fontSize: onWideLayout ? 32 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context)!.establishedIn2023, // Placeholder
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.blue.shade700, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, {bool onWideLayout = false}) {
    final stats = [
      _buildStatItem(Icons.star, AppLocalizations.of(context)!.rating, "4.4"),
      _buildStatItem(Icons.people, AppLocalizations.of(context)!.students, "0"),
      _buildStatItem(
        Icons.location_city,
        AppLocalizations.of(context)!.campus,
        AppLocalizations.of(context)!.online,
      ),
    ];

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          stats[0],
          const VerticalDivider(width: 20, thickness: 0.5),
          stats[1],
          const VerticalDivider(width: 20, thickness: 0.5),
          stats[2],
        ],
      ),
    );
  }
}
