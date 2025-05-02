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
            _buildStatsRow(context),
            _buildDescription(),
            _buildApplyButton(context),
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

  Widget _buildStatsRow(BuildContext context) {
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

  Widget _buildApplyButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: FutureBuilder<List<models.SchoolApplicationForm>>(
        future: school.getApplicationForms(),
        builder: (context, snapshot) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child:
                snapshot.hasError
                    ? Center(child: Icon(Icons.error_outline_rounded))
                    : snapshot.hasData
                    ? Center(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.edit_document),
                        label: Text("Start Application"),
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
                            (snapshot.data?.isNotEmpty ?? false)
                                ? () => _selectApplicationForm(
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

Future<void> _selectApplicationForm(
  BuildContext context,
  models.School school,
  models.Session session,
  models.User user,
) async {
  final forms = await school.getApplicationForms();
  if (!context.mounted) return;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.4),
    builder:
        (context) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 12,
              left: 16,
              right: 16,
              bottom: 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Select application form",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: forms.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final form = forms[index];
                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.pop(context);
                            launchApplicationForm(
                              context,
                              school,
                              session,
                              user,
                              form,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 20,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    _getFormIcon(form),
                                    color: Theme.of(context).focusColor,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        form.title,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          form.description,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey[400],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
  );
}

IconData _getFormIcon(models.SchoolApplicationForm form) {
  return Icons.school;
  /*
  switch (form.type.toLowerCase()) {
    case 'transfer':
      return Icons.swap_horiz;
    case 'international':
      return Icons.language;
    case 'graduate':
      return Icons.school;
    case 'scholarship':
      return Icons.attach_money;
    default:
      return Icons.description;
  }*/
}
