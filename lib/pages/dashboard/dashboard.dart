import 'package:flutter/material.dart';

import './base.dart';

class DashboardPage extends DashboardBase {
  const DashboardPage({super.key, required super.session, required super.user});
  @override
  Widget buildContent(BuildContext context) {
    return Text("Dashboard");
  }
}
