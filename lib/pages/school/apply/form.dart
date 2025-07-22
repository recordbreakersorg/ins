import 'package:flutter/material.dart';
import 'package:ins/models.dart' as models;
import 'package:ins/appstate.dart';
import 'package:ins/utils/email.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:ins/l10n/app_localizations.dart';

class FormFillPage extends StatefulWidget {
  final AppState appState;
  final models.SchoolApplicationForm form;
  const FormFillPage({super.key, required this.appState, required this.form});

  @override
  State<FormFillPage> createState() => _FormFillPageState();
}

class _FormFillPageState extends State<FormFillPage> {
  int questionIndex = 0;
  Map<int, dynamic> answers = {};
  Map<int, String?> errors = {};
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    answers = {};
    errors = {};
  }

  @override
  Widget build(BuildContext context) {
    final questions = widget.form.questions;
    final bool isLastQuestion = questionIndex == questions.length - 1;
    final bool isReviewPage = questionIndex == questions.length;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_sharp),
        ),
        title: Text(widget.form.title),
        bottom: questionIndex < questions.length
            ? PreferredSize(
                preferredSize: const Size.fromHeight(8.0),
                child: LinearProgressIndicator(
                  value: (questionIndex + 1) / questions.length,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primary.withAlpha(15),
                ),
              )
            : null,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: questions.length + 1,
              onPageChanged: (index) {
                setState(() {
                  questionIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return index == questions.length
                    ? _buildReviewWidget(context)
                    : _buildQuestionWidget(context, questions[index]);
              },
            ),
          ),
          _buildNavigation(isLastQuestion, isReviewPage),
        ],
      ),
    );
  }

  String? _validateQuestion(
    models.SchoolApplicationFormQuestion question,
    dynamic answer,
  ) {
    if (question.required) {
      if (answer == null) {
        return "This field is required.";
      }
      if (answer is String && answer.isEmpty) {
        return "This field is required.";
      }
      if (answer is Set && answer.isEmpty) {
        return "Please select at least one option.";
      }
    }

    switch (question.questionType) {
      case models.SchoolApplicationFormQuestionType.email:
        if (answer is String) {
          return checkEmail(context, answer);
        }
        break;
      case models.SchoolApplicationFormQuestionType.phone:
        if (answer is String && answer.length < 9) {
          return "Please enter a valid phone number.";
        }
        break;
      default:
        break;
    }

    return null;
  }

  Widget _buildReviewWidget(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Please review your entries",
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.form.questions.length,
            itemBuilder: (BuildContext context, int index) {
              final question = widget.form.questions[index];
              final answer = answers[question.id];
              final error = errors[question.id];
              final bool hasError = error != null;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                color: hasError
                    ? Theme.of(context).colorScheme.error.withOpacity(0.1)
                    : null,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(
                    question.questionText,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      answer != null && answer.toString().isNotEmpty
                          ? answer.toString()
                          : "No answer provided",
                      style: TextStyle(
                        color: answer != null && answer.toString().isNotEmpty
                            ? Theme.of(context).textTheme.bodyLarge?.color
                            : Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                  trailing: hasError
                      ? Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.error,
                        )
                      : IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _gotoQuestion(index),
                          tooltip: 'Edit Answer',
                        ),
                  onTap: () => _gotoQuestion(index),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation(bool isLastQuestion, bool isReviewPage) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (questionIndex > 0)
            TextButton.icon(
              onPressed: _previousQuestion,
              icon: const Icon(Icons.arrow_back_sharp),
              label: const Text("Previous"),
            ),
          const Spacer(),
          if (!isReviewPage)
            TextButton(
              onPressed: () {
                if (_validateCurrentPage()) {
                  _gotoQuestion(widget.form.questions.length);
                }
              },
              child: const Text("Review"),
            ),
          const SizedBox(width: 16),
          FilledButton.icon(
            onPressed: isReviewPage
                ? _submitForm
                : isLastQuestion
                ? () {
                    if (_validateCurrentPage()) {
                      _gotoQuestion(widget.form.questions.length);
                    }
                  }
                : _nextQuestion,
            icon: Icon(
              isReviewPage || isLastQuestion
                  ? Icons.check_circle_outline
                  : Icons.arrow_forward_sharp,
            ),
            label: Text(
              isReviewPage
                  ? "Submit"
                  : isLastQuestion
                  ? "Review"
                  : "Next",
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${questionIndex + 1} / ${widget.form.questions.length}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Text(
            question.questionText,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (question.required)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                '* Required',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          const SizedBox(height: 24),
          _buildQuestionInputField(context, question),
        ],
      ),
    );
  }

  Widget _buildQuestionInputField(
    BuildContext context,
    models.SchoolApplicationFormQuestion question,
  ) {
    final errorText = errors[question.id];
    switch (question.questionType) {
      case models.SchoolApplicationFormQuestionType.string:
        return TextFormField(
          initialValue: answers[question.id] as String?,
          onChanged: (value) {
            answers[question.id] = value;
            setState(() {
              errors[question.id] = _validateQuestion(
                question,
                answers[question.id],
              );
            });
          },
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: "Your answer",
            errorText: errorText,
          ),
        );
      case models.SchoolApplicationFormQuestionType.int:
        return TextFormField(
          initialValue: answers[question.id]?.toString(),
          onChanged: (value) {
            answers[question.id] = int.tryParse(value);
            setState(() {
              errors[question.id] = _validateQuestion(
                question,
                answers[question.id],
              );
            });
          },
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: "Enter a number",
            errorText: errorText,
          ),
        );
      case models.SchoolApplicationFormQuestionType.email:
        return TextFormField(
          initialValue: answers[question.id] as String?,
          onChanged: (value) {
            answers[question.id] = value;
            setState(() {
              errors[question.id] = _validateQuestion(
                question,
                answers[question.id],
              );
            });
          },
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'bananana@example.cm',
            errorText: errorText,
          ),
        );
      case models.SchoolApplicationFormQuestionType.phone:
        return InternationalPhoneNumberInput(
          onInputChanged: (PhoneNumber number) {
            answers[question.id] = number.phoneNumber;
            setState(() {
              errors[question.id] = _validateQuestion(
                question,
                answers[question.id],
              );
            });
          },
          selectorConfig: const SelectorConfig(
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          ),
          ignoreBlank: false,
          initialValue: PhoneNumber(
            phoneNumber: answers[question.id] as String?,
            isoCode: 'CM',
          ),
          autoValidateMode: AutovalidateMode.onUserInteraction,
          formatInput: true,
          keyboardType: const TextInputType.numberWithOptions(
            signed: true,
            decimal: true,
          ),
          inputDecoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: "Phone number",
            errorText: errorText,
          ),
        );
      case models.SchoolApplicationFormQuestionType.date:
        return TextFormField(
          readOnly: true,
          controller: TextEditingController(
            text: answers[question.id] == null
                ? ''
                : (answers[question.id] as DateTime).toLocal().toString().split(
                    ' ',
                  )[0],
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: answers[question.id] as DateTime? ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              setState(() {
                answers[question.id] = pickedDate;
                errors[question.id] = _validateQuestion(
                  question,
                  answers[question.id],
                );
              });
            }
          },
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: "Select a date",
            suffixIcon: const Icon(Icons.calendar_today),
            errorText: errorText,
          ),
        );
      case models.SchoolApplicationFormQuestionType.bool:
        return SwitchListTile(
          title: Text(question.questionText),
          value: answers[question.id] as bool? ?? false,
          onChanged: (bool value) {
            setState(() {
              answers[question.id] = value;
              errors[question.id] = _validateQuestion(
                question,
                answers[question.id],
              );
            });
          },
        );
      case models.SchoolApplicationFormQuestionType.select:
        List<String> options = (question.options['choices'] as List<dynamic>)
            .map((e) => e.toString())
            .toList();
        return DropdownButtonFormField<String>(
          value: answers[question.id] as String?,
          items: options.map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              answers[question.id] = newValue;
              errors[question.id] = _validateQuestion(
                question,
                answers[question.id],
              );
            });
          },
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: "Select an option",
            errorText: errorText,
          ),
        );
      case models.SchoolApplicationFormQuestionType.checkbox:
        List<String> options = (question.options['choices'] as List<dynamic>)
            .map((e) => e.toString())
            .toList();
        answers[question.id] ??= <String>{};
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...options.map((option) {
              return CheckboxListTile(
                title: Text(option),
                value: (answers[question.id] as Set<String>).contains(option),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      (answers[question.id] as Set<String>).add(option);
                    } else {
                      (answers[question.id] as Set<String>).remove(option);
                    }
                    errors[question.id] = _validateQuestion(
                      question,
                      answers[question.id],
                    );
                  });
                },
              );
            }).toList(),
            if (errorText != null)
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                child: Text(
                  errorText,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      case models.SchoolApplicationFormQuestionType.file:
        return const Text("File uploads are not supported in this version.");
    }
  }

  void _previousQuestion() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  bool _validateCurrentPage() {
    final question = widget.form.questions[questionIndex];
    final error = _validateQuestion(question, answers[question.id]);
    setState(() {
      errors[question.id] = error;
    });
    return error == null;
  }

  void _nextQuestion() {
    if (_validateCurrentPage()) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _gotoQuestion(int index) {
    _pageController.jumpToPage(index);
  }

  void _submitForm() {
    bool allValid = true;
    for (var question in widget.form.questions) {
      final error = _validateQuestion(question, answers[question.id]);
      if (error != null) {
        allValid = false;
      }
      setState(() {
        errors[question.id] = error;
      });
    }

    if (allValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Form submitted! (Not really)")),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fix the errors before submitting."),
          backgroundColor: Colors.red,
        ),
      );
      // Jump to the review page to show all errors
      _gotoQuestion(widget.form.questions.length);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

