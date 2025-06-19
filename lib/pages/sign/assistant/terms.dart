import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ins/backend/backend.dart';
import './manager.dart';
import './base.dart';
import './namechooser.dart';
import 'package:ins/errorpage.dart';

class TermsPage extends StatefulWidget {
  final SignupAssistantState assistantState;
  const TermsPage({super.key, required this.assistantState});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  bool _hasAgreed = false;
  late Future<String?> _termsFuture; // To avoid refetching on rebuilds

  @override
  void initState() {
    super.initState();
    _termsFuture = getTerms();
  }

  Widget _buildTermsContent(BuildContext context, String termsData) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ClipRRect(
        // Ensures scrollbar is also clipped by border radius
        borderRadius: BorderRadius.circular(
          7.0,
        ), // slightly less than container
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            child: MarkdownBody(
              data: termsData,
              selectable: true, // Allows users to select text
              styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                p: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  height: 1.5,
                ),
                h1: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                h2: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                // Add more custom styles if needed
              ),
              onTapLink: (text, href, title) {
                // Handle link taps if needed, e.g., open in a browser
                // For now, it will use the default behavior
                print('Tapped link: $href');
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextWidget(BuildContext context) {
    return FutureBuilder<String?>(
      future: _termsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.isEmpty ||
            snapshot.data == null) {
          // You might want to provide a retry mechanism or a more specific error message
          return Center(
            child: ErrorPage(
              title: "Failed to Load Terms",
              description:
                  snapshot.hasError
                      ? "Sorry, an error occurred while fetching our terms and conditions. Please check your internet connection and try again."
                      : "Terms and conditions are currently unavailable. Please try again later.",
              // You could add a retry button to ErrorPage that calls setState(() { _termsFuture = getTerms(); })
            ),
          );
        } else {
          // Data has been successfully loaded
          return _buildTermsContent(context, snapshot.data!);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AssistantBasePage(
      title: const Text("Terms & Conditions"),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          16.0,
          16.0,
          16.0,
          24.0,
        ), // More bottom padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Please review and accept our terms and conditions to continue.",
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(child: _buildTextWidget(context)),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text(
                "I have read and agree to the terms and conditions.",
              ),
              value: _hasAgreed,
              onChanged: (bool? value) {
                setState(() {
                  _hasAgreed = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: theme.colorScheme.primary,
              dense: true,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: const Icon(Icons.check_circle_outline),
              label: const Text("Accept & Continue"),
              onPressed:
                  _hasAgreed
                      ? () {
                        // Logic to mark terms as accepted if needed
                        // e.g., widget.assistantState.markTermsAccepted();
                        Navigator.pushReplacement(
                          // Use pushReplacement if they shouldn't go back to terms
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => NameChooserPage(
                                  assistantState: widget.assistantState,
                                ),
                          ),
                        );
                      }
                      : null, // Button is disabled if not agreed
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: theme.textTheme.labelLarge?.copyWith(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), // Softer corners
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
