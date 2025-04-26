import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../backend/models.dart' as models;
import './profile.dart';

class NotificationFeedView extends StatelessWidget {
  final models.UserFeed feed;
  final Future<void> Function(models.UserFeed) dismiss;
  const NotificationFeedView({
    super.key,
    required this.feed,
    required this.dismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: profileAvatar(
                        radius: 40,
                        imagePath: feed.imagePath,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        feed.title,
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 16,
                  ),
                  child: MarkdownBody(
                    data: feed.content,
                    styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                      p: GoogleFonts.lato(
                        fontSize: 16,
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (feed.feedType) {
      case "notification":
        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    dismiss(feed);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      colorScheme.error.withOpacity(0.2),
                    ),
                    foregroundColor: WidgetStateProperty.all(colorScheme.error),
                  ),
                  child: Text("Dismiss"),
                ),
              ),
            ],
          ),
        );
      case "chat-message":
        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      colorScheme.error.withOpacity(0.2),
                    ),
                    foregroundColor: WidgetStateProperty.all(colorScheme.error),
                  ),
                  child: Text("Dismiss"),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                child: Text("View >"),
              ),
            ],
          ),
        );
      default:
        return Container();
    }
  }
}
