import 'package:flutter/material.dart';
import 'package:ins/backend/models.dart' as models;

class ApplicationFormReviewPage extends StatefulWidget {
  final models.SchoolApplicationFormAttempt attempt;
  final models.SchoolApplicationForm form;
  final models.Session session;
  final models.SchoolMember member;
  final models.User user;
  const ApplicationFormReviewPage({
    super.key,
    required this.attempt,
    required this.form,
    required this.session,
    required this.member,
    required this.user,
  });

  @override
  State<ApplicationFormReviewPage> createState() =>
      _ApplicationFormReviewPageState();
}

class _ApplicationFormReviewPageState extends State<ApplicationFormReviewPage> {
  bool _isProcessing = false;
  String? _resultMessage;

  Future<void> _handleDecision(bool accepted) async {
    setState(() {
      _isProcessing = true;
      _resultMessage = null;
    });
    if (accepted) {
      final role = await showModalBottomSheet<String>(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                Text(
                  "Select the role for the new user:",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: 16),
                ListTile(
                  title: Text("Student"),
                  onTap: () => Navigator.pop(context, 'student'),
                ),
                ListTile(
                  title: Text("Teacher"),
                  onTap: () => Navigator.pop(context, 'teacher'),
                ),
                ListTile(
                  title: Text("Parent"),
                  onTap: () => Navigator.pop(context, 'parent'),
                ),
                ListTile(
                  title: Text("Admin"),
                  onTap: () => Navigator.pop(context, 'admin'),
                ),
              ],
            ),
          );
        },
      );
      if (role != null) {
        await widget.attempt.accept(widget.session, role);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
    } else {
      await widget.attempt.decline(widget.session);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      return;
    }
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isProcessing = false;
      _resultMessage =
          accepted ? "Application accepted." : "Application declined.";
    });
  }

  @override
  Widget build(BuildContext context) {
    final answers = widget.attempt.answers;
    final questions = widget.form.questions;
    return Scaffold(
      appBar: AppBar(title: Text("Review Application")),
      body:
          _isProcessing
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: questions.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, idx) {
                          final q = questions[idx];
                          final a = answers.firstWhere(
                            (ans) => ans.questionNumber == q.number,
                            orElse:
                                () => models.SchoolApplicationFormAttemptAnswer(
                                  questionNumber: q.number,
                                  content: '',
                                ),
                          );
                          return ListTile(
                            title: Text(
                              q.question,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              a.content.isNotEmpty ? a.content : "(No answer)",
                            ),
                          );
                        },
                      ),
                    ),
                    if (_resultMessage != null) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          _resultMessage!,
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.check),
                          label: Text("Accept"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          onPressed:
                              _isProcessing
                                  ? null
                                  : () => _handleDecision(true),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.close),
                          label: Text("Decline"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed:
                              _isProcessing
                                  ? null
                                  : () => _handleDecision(false),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }
}
