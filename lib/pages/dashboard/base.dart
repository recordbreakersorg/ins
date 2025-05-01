import 'package:flutter/material.dart';
import 'package:ins/backend/models.dart';
import 'appbar.dart';
import './nav.dart';
import './dashboardnav.dart';
import '../../analytics.dart' as analytics;

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DashboardBase extends StatelessWidget {
  final Session session;
  final User user;
  final int navIndex;
  final String title;
  const DashboardBase({
    super.key,
    required this.session,
    required this.user,
    required this.navIndex,
    required this.title,
  });
  Widget buildContent(BuildContext context) {
    return Center(
      child: Text(AppLocalizations.of(context)!.dashboardBaseContent),
    );
  }

  @override
  Widget build(BuildContext context) {
    analytics.screen("Dashboard:$title");
    return Scaffold(
      appBar: dashboardAppBar(title, session, user),
      drawer: dashboardNav(context, session, user),
      endDrawer: dashboardAccountNav(context, session, user),
      body: buildContent(context),
      bottomNavigationBar: dashboardBottomNav(context, session, user, navIndex),
    );
  }
}
