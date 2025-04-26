import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import '../../../backend/models.dart' as models;
import './manager.dart';
import './base.dart';
import './submiting.dart';

class QuestionsPage extends AssistantBasePage {
  const QuestionsPage({
    super.key,
    super.title = const Text("Application Form"),
    required super.session,
    required super.user,
    required super.school,
    required super.assistantState,
    required super.form,
  });

  @override
  Widget buildContent(BuildContext context) {
    return _QuestionsView(
      form: form,
      assistantState: assistantState,
      session: session,
      user: user,
      school: school,
    );
  }
}

class _QuestionsView extends StatefulWidget {
  final models.SchoolApplicationForm form;
  final models.Session session;
  final models.User user;
  final models.School school;
  final AssistantState assistantState;

  const _QuestionsView({
    required this.form,
    required this.assistantState,
    required this.session,
    required this.user,
    required this.school,
  });

  @override
  State<_QuestionsView> createState() => _QuestionsViewState();
}

class _QuestionsViewState extends State<_QuestionsView>
    with SingleTickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  late AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();
  String? _currentError;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _nextQuestion() async {
    if (!_validateCurrentQuestion()) return;

    await _animationController.forward();
    if (_currentQuestionIndex < widget.form.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _currentError = null;
        _animationController.reset();
      });
    } else {
      _submitAnswers();
    }
  }

  bool _validateCurrentQuestion() {
    final question = widget.form.questions[_currentQuestionIndex];
    final answer = widget.assistantState.answers[question.number];

    if (question.required && (answer == null || answer.isEmpty)) {
      setState(() => _currentError = 'This question is required');
      return false;
    }
    return true;
  }

  void _back() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _currentError = null;
      });
    }
  }

  void _onAnswerChanged(
    models.SchoolApplicationFormQuestion question,
    String value,
  ) {
    widget.assistantState.setAnswer(question.number, value);
  }

  void _submitAnswers() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder:
            (context, animation, secondaryAnimation) => SubmitingFormPage(
              session: widget.session,
              user: widget.user,
              school: widget.school,
              assistantState: widget.assistantState,
              form: widget.form,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Widget _buildQuestionContent(models.SchoolApplicationFormQuestion question) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      child: Form(
        key: _formKey,
        child: Column(
          key: ValueKey(_currentQuestionIndex),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressIndicator(),
            const SizedBox(height: 16),
            _buildQuestionCard(question),
            if (_currentError != null) _buildErrorText(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return LinearProgressIndicator(
      value: (_currentQuestionIndex + 1) / widget.form.questions.length,
      backgroundColor: Colors.grey.shade200,
      valueColor: AlwaysStoppedAnimation<Color>(
        Theme.of(context).colorScheme.primary,
      ),
      minHeight: 8,
      borderRadius: BorderRadius.circular(4),
    );
  }

  Widget _buildQuestionCard(models.SchoolApplicationFormQuestion question) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Question ${_currentQuestionIndex + 1} of ${widget.form.questions.length}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            MarkdownBody(
              data: question.question,
              styleSheet: MarkdownStyleSheet(
                p: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
                h1: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                h2: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                blockquote: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade600,
                  backgroundColor: Colors.grey.shade100,
                ),
                blockquotePadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 32),
            _buildAnswerField(question),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerField(models.SchoolApplicationFormQuestion question) {
    final currentValue = widget.assistantState.answers[question.number];

    switch (question.type) {
      case 'int':
        return TextFormField(
          keyboardType: TextInputType.number,
          onChanged: (value) => _onAnswerChanged(question, value),
          controller: TextEditingController(
            text: currentValue?.toString() ?? '',
          ),
          decoration: InputDecoration(
            labelText: 'Enter your answer',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
          validator:
              (value) =>
                  question.required && (value == null || value.isEmpty)
                      ? 'This field is required'
                      : null,
        );
      case 'date':
        final date = DateTime.tryParse(currentValue?.toString() ?? '');
        return GestureDetector(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (selectedDate != null) {
              _onAnswerChanged(question, selectedDate.toIso8601String());
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Select date',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            child: Text(
              date != null
                  ? DateFormat('MMM dd, yyyy').format(date)
                  : 'Tap to select date',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        );
      case 'string':
      default:
        return TextFormField(
          onChanged: (value) => _onAnswerChanged(question, value),
          controller: TextEditingController(text: currentValue ?? ''),
          decoration: InputDecoration(
            labelText: 'Enter your answer',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
          validator:
              (value) =>
                  question.required && (value == null || value.isEmpty)
                      ? 'This field is required'
                      : null,
        );
    }
  }

  Widget _buildErrorText() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 16),
      child: Text(
        _currentError!,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.form.questions[_currentQuestionIndex];
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _currentQuestionIndex > 0 ? _back : null,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _buildQuestionContent(question),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _nextQuestion,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _currentQuestionIndex < widget.form.questions.length - 1
                          ? 'Continue'
                          : 'Submit Application',
                    ),
                    if (_currentQuestionIndex <
                        widget.form.questions.length - 1)
                      const SizedBox(width: 8),
                    if (_currentQuestionIndex <
                        widget.form.questions.length - 1)
                      const Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
