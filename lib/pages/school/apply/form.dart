import 'package:flutter/material.dart';
import 'package:ins/models.dart' as models;
import 'package:ins/appstate.dart';

class FormFillPage extends StatefulWidget {
  final AppState appState;
  final models.SchoolApplicationForm form;
  const FormFillPage({super.key, required this.appState, required this.form});

  @override
  State<FormFillPage> createState() => _FormFillPageState();
}

class _FormFillPageState extends State<FormFillPage> {
  int questionIndex = 0;
  Map<int, String> answers = {};
  @override
  void initState() {
    questionIndex = 0;
    answers = {};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.form.questions[questionIndex];
    // bad to recreate the whole scaffold each time, but...
    return Scaffold(
      appBar: AppBar(
        leading: OutlinedButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          label: Icon(Icons.close_sharp),
        ),
        title: Text("Applicaiton form"),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (questionIndex + 1) / widget.form.questions.length,
            backgroundColor: Theme.of(context).primaryColor,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          Row(
            children: [
              IconButton(
                onPressed: questionIndex > 0 ? _previousQuesiton : null,
                icon: Icon(Icons.arrow_back_sharp),
              ),
              SizedBox(width: double.infinity),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _previousQuesiton() {
    if (questionIndex <= 0) return;
    setState(() {
      questionIndex--;
    });
  }

  void _nextQuesiton() {
    if (questionIndex >= widget.form.questions.length - 1) return;
    setState(() {
      questionIndex--;
    });
  }
}
