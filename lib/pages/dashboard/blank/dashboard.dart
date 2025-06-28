import 'package:flutter/material.dart';
import 'package:ins/appstate.dart';

class BlankDashboard extends StatelessWidget {
  final AppState appState;
  const BlankDashboard({super.key, required this.appState});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Are we going?")),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                // open settings
              },
            ),
          ],
        ),
      ),
    );
  }
}
