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
    if (widget.form.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Application form")),
        body: Center(child: Text("No questions to display.")),
      );
    } else {
      questionIndex = questionIndex.clamp(0, widget.form.questions.length - 1);
    }
    final question = widget.form.questions[questionIndex];
    // bad to recreate the whole scaffold each time, but...
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.close_sharp),
        ),
        title: Text("Applicaiton form"),
      ),
      body: Column(
        children: [
          Text(
            "Question ${questionIndex + 1} of ${widget.form.questions.length}",
          ),
          LinearProgressIndicator(
            value: (questionIndex + 1) / widget.form.questions.length,
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
            ],
          ),
          const SizedBox(height: 20),
          _buildQuestionWidget(context, question),
          Spacer(),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: FilledButton(
                onPressed: _nextQuesiton,
                child: Text("next >"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionWidget(
    BuildContext context,
    models.SchoolApplicationFormQuestion question,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.questionText,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
          Hero(
            tag: "school-application-form-question-entry",
            child: _buildQuestionInputField(context, question),
          ),

          // Add more question types as needed
        ],
      ),
    );
  }

  Widget _buildQuestionInputField(
    BuildContext context,
    models.SchoolApplicationFormQuestion question,
  ) {
    if (question.questionType ==
        models.SchoolApplicationFormQuestionType.string) {
      return TextField(
        onChanged: (value) {
          answers[question.id] = value;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Your answer',
        ),
      );
    } else {
      return Text("Unsupported question type: ${question.questionType}");
    }
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
      questionIndex++;
    });
  }
}
