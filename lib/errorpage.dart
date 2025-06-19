import 'package:flutter/material.dart';
import '../analytics.dart' as analytics;

class ErrorPage extends StatelessWidget {
  final String title;
  final String description;
  final Widget? icon;
  const ErrorPage({
    super.key,
    required this.title,
    required this.description,
    this.icon,
  });
  @override
  Widget build(BuildContext context) {
    analytics.screen("ErrorPage");
    analytics.logEvent(
      name: "ErrorPage",
      parameters: {"title": title, "description": description},
    );
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon ??
                Icon(
                  Icons.error_outline,
                  size: 200,
                  color: Theme.of(context).colorScheme.error,
                ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
