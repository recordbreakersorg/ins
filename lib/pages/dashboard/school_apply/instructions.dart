import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'base.dart';
import './questions.dart';

class ApplicationFormInstructionsPage extends AssistantBasePage {
  const ApplicationFormInstructionsPage({
    super.key,
    super.title = "Instructions",
    required super.session,
    required super.user,
    required super.school,
    required super.assistantState,
    required super.form,
  });

  @override
  Widget buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(
            "Instructions",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: MarkdownBody(
              data: form.instructions,
              styleSheet: MarkdownStyleSheet(p: GoogleFonts.poppins()),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => QuestionsPage(
                          assistantState: assistantState,
                          user: user,
                          school: school,
                          session: session,
                          form: form,
                        ),
                  ),
                );
              },
              child: Text("Next"),
            ),
          ),
        ],
      ),
    );
  }
}
