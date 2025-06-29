import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ins/models.dart' as models;
import 'package:transparent_image/transparent_image.dart';
import 'package:ins/appstate.dart';

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
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return _buildWideLayout(context);
          } else {
            return _buildNarrowLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context, onWideLayout: true),
                const SizedBox(height: 24),
                _buildSchoolHeader(onWideLayout: true),
                const SizedBox(height: 24),
                _buildStatsRow(context),
                const SizedBox(height: 24),
                _buildDescription(onWideLayout: true),
                const SizedBox(height: 32),
                _buildApplyButton(context),
                const SizedBox(height: 24),
                _buildAdditionalInfo(onWideLayout: true),
              ],
            ),
          ),
        ),
        if (school.logoUrl != null)
          Expanded(
            flex: 3,
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: school.logoUrl!,
              fit: BoxFit.cover,
              height: double.infinity,
              imageErrorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade300,
                child: const Center(child: Icon(Icons.error)),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return Stack(
      children: [
        _buildHeroBackground(),
        _buildScrim(),
        SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context),
                const SizedBox(height: 24),
                _buildSchoolHeader(),
                const SizedBox(height: 24),
                _buildStatsRow(context),
                const SizedBox(height: 24),
                _buildDescription(),
                const SizedBox(height: 32),
                Center(child: _buildApplyButton(context)),
                const SizedBox(height: 24),
                _buildAdditionalInfo(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo({bool onWideLayout = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        color: onWideLayout
            ? Colors.grey.shade100
            : Colors.white.withOpacity(0.85),
        elevation: onWideLayout ? 0 : 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [_buildInfoItem(Icons.location_on, school.address)],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, {bool onWideLayout = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: onWideLayout ? Colors.black87 : Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    return FilledButton.icon(
      onPressed: null, // TODO: Implement application logic
      icon: const Icon(Icons.edit_document),
      label: const Text("Apply"),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDescription({bool onWideLayout = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: MarkdownBody(
        data: school.description ?? "No description provided.",
        styleSheet: MarkdownStyleSheet(
          p: GoogleFonts.poppins(
            fontSize: 16,
            color: onWideLayout
                ? Colors.black87.withOpacity(0.7)
                : Colors.white.withOpacity(0.85),
            height: 1.6,
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBackground() {
    return Hero(
      tag: 'school-bg-${school.id}',
      child: Container(
        decoration: BoxDecoration(
          image: school.logoUrl != null
              ? DecorationImage(
                  image: NetworkImage(school.logoUrl!),
                  fit: BoxFit.cover,
                  onError: (error, stackTrace) => {},
                )
              : null,
          color: Colors.grey.shade400,
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(color: Colors.black.withOpacity(0.1)),
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

  Widget _buildSchoolHeader({bool onWideLayout = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Hero(
            tag: 'school-logo-${school.id}',
            child: CircleAvatar(
              radius: onWideLayout ? 60 : 50,
              backgroundColor: Colors.white,
              backgroundImage: school.logoUrl != null
                  ? NetworkImage(school.logoUrl!)
                  : null,
              child: school.logoUrl == null
                  ? Text(
                      school.schoolname.isNotEmpty ? school.schoolname[0] : 'S',
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              school.fullname,
              style: GoogleFonts.poppins(
                fontSize: onWideLayout ? 36 : 28,
                fontWeight: FontWeight.bold,
                color: onWideLayout ? Colors.black87 : Colors.white,
                shadows: onWideLayout
                    ? []
                    : [
                        const Shadow(
                          blurRadius: 8.0,
                          color: Colors.black54,
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrim() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.2),
            Colors.black.withOpacity(0.8),
          ],
          stops: const [0.0, 0.7],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String value, {
    bool onWideLayout = false,
  }) {
    final color = onWideLayout ? Colors.black54 : Colors.white;
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, {bool onWideLayout = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.star, "4.4", onWideLayout: onWideLayout),
          _buildStatItem(Icons.people, "0", onWideLayout: onWideLayout),
          _buildStatItem(
            Icons.location_city,
            "Somewhere",
            onWideLayout: onWideLayout,
          ),
        ],
      ),
    );
  }
}



//IconData _getFormIcon(models.SchoolApplicationForm form) {
//  return Icons.school;
//  /*
//  switch (form.type.toLowerCase()) {
//    case 'transfer':
//      return Icons.swap_horiz;
//    case 'international':
//      return Icons.language;
//    case 'graduate':
//      return Icons.school;
//    case 'scholarship':
//      return Icons.attach_money;
//    default:
//      return Icons.description;
//  }*/
//}

//Future<void> _selectApplicationForm(
//BuildContext context,
//models.School school,
//models.Session session,
//models.User user,
//) async {
//  final forms = await school.getApplicationForms();
//  if (!context.mounted) return;
//
//  showModalBottomSheet(
//    context: context,
//    isScrollControlled: true,
//    backgroundColor: Colors.transparent,
//    barrierColor: Colors.black.withOpacity(0.4),
//    builder: (context) => Container(
//      decoration: BoxDecoration(
//        color: Theme.of(context).scaffoldBackgroundColor,
//        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
//      ),
//      child: Padding(
//        padding: const EdgeInsets.only(
//          top: 12,
//          left: 16,
//          right: 16,
//          bottom: 24,
//        ),
//        child: Column(
//          mainAxisSize: MainAxisSize.min,
//          children: [
//            Center(
//              child: Container(
//                width: 40,
//                height: 4,
//                decoration: BoxDecoration(
//                  color: Colors.grey[400],
//                  borderRadius: BorderRadius.circular(2),
//                ),
//              ),
//            ),
//            const SizedBox(height: 16),
//            Text(
//              "Select application form",
//              style: GoogleFonts.poppins(
//                fontSize: 22,
//                fontWeight: FontWeight.w600,
//                color: Theme.of(context).primaryColor,
//              ),
//            ),
//            const SizedBox(height: 24),
//            Flexible(
//              child: ListView.separated(
//                shrinkWrap: true,
//                physics: const ClampingScrollPhysics(),
//                itemCount: forms.length,
//                separatorBuilder: (_, __) => const Divider(height: 1),
//                itemBuilder: (context, index) {
//                  final form = forms[index];
//                  return Material(
//                    color: Colors.transparent,
//                    child: InkWell(
//                      borderRadius: BorderRadius.circular(12),
//                      onTap: () {
//                        Navigator.pop(context);
//                        launchApplicationForm(
//                          context,
//                          school,
//                          session,
//                          user,
//                          form,
//                        );
//                      },
//                      child: Container(
//                        padding: const EdgeInsets.symmetric(
//                          vertical: 16,
//                          horizontal: 20,
//                        ),
//                        child: Row(
//                          children: [
//                            Container(
//                              padding: const EdgeInsets.all(12),
//                              decoration: BoxDecoration(
//                                color: Theme.of(
//                                  context,
//                                ).primaryColor.withOpacity(0.1),
//                                borderRadius: BorderRadius.circular(12),
//                              ),
//                              child: Icon(
//                                _getFormIcon(form),
//                                color: Theme.of(context).focusColor,
//                                size: 28,
//                              ),
//                            ),
//                            const SizedBox(width: 20),
//                            Expanded(
//                              child: Column(
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                children: [
//                                  Text(
//                                    form.title,
//                                    style: GoogleFonts.poppins(
//                                      fontSize: 16,
//                                      fontWeight: FontWeight.w600,
//                                    ),
//                                  ),
//                                  Padding(
//                                    padding: const EdgeInsets.only(top: 4),
//                                    child: Text(
//                                      form.description,
//                                      style: GoogleFonts.poppins(
//                                        fontSize: 14,
//                                        color: Colors.grey[600],
//                                      ),
//                                      maxLines: 2,
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            ),
//                            Icon(Icons.chevron_right, color: Colors.grey[400]),
//                          ],
//                        ),
//                      ),
//                    ),
//                  );
//                },
//              ),
//            ),
//          ],
//        ),
//      ),
//    ),
//  );
//}


