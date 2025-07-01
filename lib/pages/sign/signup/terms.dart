import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ins/utils/terms.dart' as terms;
import 'package:ins/widgets/imsg.dart';
import 'package:ins/widgets/loading.dart';
import 'form.dart';
import 'base.dart';
import 'namepassword.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ins/l10n/app_localizations.dart';

class TermsPage extends StatelessWidget {
  final SignupForm form;
  const TermsPage({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return FutureBuilder(
      future: terms.getTerms(locale, "md"),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return TermsWidget(form: form, termsMarkdown: snapshot.data!);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text("Loading terms ")),
            body: LoadingWidget(
              messages: AppLocalizations.of(
                context,
              )!.waitingMessages.split("|"),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(title: Text("Error")),
            body: IMsgWidget(
              icon: Icon(Icons.error_rounded, size: 150, color: Colors.red),
              message: Text(snapshot.error.toString()),
            ),
          );
        }
      },
    );
  }
}

class TermsWidget extends StatefulWidget {
  final SignupForm form;
  final String termsMarkdown;
  const TermsWidget({
    super.key,
    required this.form,
    required this.termsMarkdown,
  });

  @override
  State<TermsWidget> createState() => _TermsWidgetState();
}

class _TermsWidgetState extends State<TermsWidget> {
  bool _termsAccepted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Terms & Conditions")),
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
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
                        data: widget.termsMarkdown,
                        selectable: true, // Allows users to select text
                        styleSheet:
                            MarkdownStyleSheet.fromTheme(
                              Theme.of(context),
                            ).copyWith(
                              // Improve theme
                              p: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontSize: 15, height: 1.5),
                              h1: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              h2: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              // Add more custom styles if needed
                            ),
                        onTapLink: (text, href, title) {
                          if (href == null) return;
                          launchUrl(Uri.parse(href));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text(
                "I have read and agree to the terms and conditions.",
              ),
              value: _termsAccepted,
              onChanged: (bool? value) {
                setState(() {
                  _termsAccepted = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: Theme.of(context).colorScheme.primary,
              dense: true,
            ),
            const SizedBox(height: 24.0), // Spacing before the button
            FilledButton(
              onPressed: _termsAccepted
                  ? () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NamePasswordPage(form: widget.form),
                        ),
                      );
                    }
                  : null,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text("Accept & Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
