import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class NotificationFeedView extends StatelessWidget {
  final String title;
  final String description;
  final String? imageWebPath; // a notification may have no image
  final String? link; // a notification may have no link
  final String time;
  const NotificationFeedView({
    super.key,
    required this.title,
    required this.description,
    this.imageWebPath,
    this.link,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: colorScheme.outline, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  children: [
                    if (imageWebPath != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(imageWebPath!),
                          radius: 30,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        title,
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
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: MarkdownBody(
                    data: description,
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
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            colorScheme.error.withOpacity(0.2),
                          ),
                          foregroundColor: MaterialStateProperty.all(
                            colorScheme.error,
                          ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
