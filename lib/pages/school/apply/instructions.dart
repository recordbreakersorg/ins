import 'package:flutter/material.dart';
import 'package:ins/appstate.dart';
import 'package:ins/models.dart' as models;
import 'form.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:ins/l10n/app_localizations.dart';

class InstructionsPage extends StatelessWidget {
  final AppState appState;
  final models.SchoolApplicationForm form;
  const InstructionsPage({
    super.key,
    required this.appState,
    required this.form,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(form.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MarkdownBody(
                      data: form.instructions ?? '',
                      selectable: true,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(fontSize: 20.0),
                        h1: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                        h2: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        h3: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                          FormFillPage(appState: appState, form: form),
                    ),
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.underscorestartApplication,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
