import 'package:flutter/material.dart';
import '../../../backend/models.dart';
import './appbar.dart';
import './nav.dart';

class DashboardBase extends StatelessWidget {
  final Session session;
  final User user;
  const DashboardBase({super.key, required this.session, required this.user});
  Widget buildContent(BuildContext context) {
    return const Center(child: Text('Dashboard Base Content'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: dashboardAppBar("Home", session, user),
      drawer: dashboardNav(context, session, user),
      endDrawer: dashboardAccountNav(context, session, user),
      body: buildContent(context),
    );
  }
}
