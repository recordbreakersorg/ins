import 'package:flutter/material.dart';
import './base.dart';
import './errorpage.dart';

class DashboardClassroomsPage extends DashboardBase {
  const DashboardClassroomsPage({
    super.key,
    super.navIndex = 1,
    super.title = "Your classrooms",
    required super.session,
    required super.user,
  });
  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: user.getClassrooms(session),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const ErrorPage(
              title: "Error",
              description: "Unable to load classrooms",
            );
          }
          return CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          );
        },
      ),
    );
  }
}
