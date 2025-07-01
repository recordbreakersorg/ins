import 'package:flutter/material.dart';
import 'package:ins/appstate.dart';
import 'package:ins/pages/school/explore.dart';

class BlankDashboard extends StatelessWidget {
  final AppState appState;
  const BlankDashboard({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Are we going?")),
      body: Center(
        child: SizedBox(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                DashboardButton(
                  icon: Icons.edit,
                  text: "Edit Profile",
                  color: Colors.blue,
                  onPressed: () {
                    // TODO: Implement edit profile functionality
                  },
                ),
                const SizedBox(height: 20),
                DashboardButton(
                  icon: Icons.settings,
                  text: "Edit Preferences",
                  color: Colors.orange,
                  onPressed: () {
                    // TODO: Implement edit preferences functionality
                  },
                ),
                const SizedBox(height: 20),
                DashboardButton(
                  icon: Icons.school,
                  text: "Browse Schools",
                  color: Colors.green,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            SchoolExplorePage(appState: appState),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const DashboardButton({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withAlpha(30),
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color, width: 2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 40, color: color),
                  const SizedBox(width: 20),
                  Text(
                    text,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
