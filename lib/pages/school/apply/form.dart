import 'package:flutter/material.dart';
import 'package:ins/models.dart' as models;
import 'package:ins/appstate.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

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
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    answers = {};
  }

  @override
  Widget build(BuildContext context) {
    final questions = widget.form.questions;
    final bool isLastQuestion = questionIndex == questions.length - 1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close_sharp),
        ),
        title: Text(widget.form.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(8.0),
          child: LinearProgressIndicator(
            value: (questionIndex + 1) / questions.length,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.2),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: questions.length,
              onPageChanged: (index) {
                setState(() {
                  questionIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return _buildQuestionWidget(context, questions[index]);
              },
            ),
          ),
          _buildNavigation(isLastQuestion),
        ],
      ),
    );
  }

  Widget _buildNavigation(bool isLastQuestion) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (questionIndex > 0)
            TextButton.icon(
              onPressed: _previousQuestion,
              icon: const Icon(Icons.arrow_back_sharp),
              label: const Text("PREVIOUS"),
            ),
          const Spacer(),
          FilledButton.icon(
            onPressed: isLastQuestion ? _submitForm : _nextQuestion,
            icon: Icon(
              isLastQuestion
                  ? Icons.check_circle_outline
                  : Icons.arrow_forward_sharp,
            ),
            label: Text(isLastQuestion ? "SUBMIT" : "NEXT"),
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
            "Question ${questionIndex + 1} of ${widget.form.questions.length}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Text(
            question.questionText,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
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
    switch (question.questionType) {
      case models.SchoolApplicationFormQuestionType.string:
        return TextFormField(
          initialValue: answers[question.id] as String?,
          onChanged: (value) => answers[question.id] = value,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Your answer',
          ),
        );
      case models.SchoolApplicationFormQuestionType.int:
        return TextFormField(
          initialValue: answers[question.id]?.toString(),
          onChanged: (value) => answers[question.id] = int.tryParse(value),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter a number',
          ),
        );
      case models.SchoolApplicationFormQuestionType.email:
        return TextFormField(
          initialValue: answers[question.id] as String?,
          onChanged: (value) => answers[question.id] = value,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'you@example.com',
          ),
        );
      case models.SchoolApplicationFormQuestionType.phone:
        return InternationalPhoneNumberInput(
          onInputChanged: (PhoneNumber number) {
            answers[question.id] = number.phoneNumber;
          },
          selectorConfig: const SelectorConfig(
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          ),
          ignoreBlank: false,
          autoValidateMode: AutovalidateMode.onUserInteraction,
          formatInput: true,
          keyboardType: const TextInputType.numberWithOptions(
            signed: true,
            decimal: true,
          ),
          inputDecoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Phone number',
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
              });
            }
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Select a date',
            suffixIcon: Icon(Icons.calendar_today),
          ),
        );
      case models.SchoolApplicationFormQuestionType.bool:
        return SwitchListTile(
          title: Text(question.questionText),
          value: answers[question.id] as bool? ?? false,
          onChanged: (bool value) {
            setState(() {
              answers[question.id] = value;
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
            });
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Select an option',
          ),
        );
      case models.SchoolApplicationFormQuestionType.checkbox:
        List<String> options = (question.options['choices'] as List<dynamic>)
            .map((e) => e.toString())
            .toList();
        answers[question.id] ??= <String>{};
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: options.map((option) {
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
                });
              },
            );
          }).toList(),
        );
      case models.SchoolApplicationFormQuestionType.file:
        return const Text("File uploads are not supported in this version.");
      default:
        return Text("Unsupported question type: ${question.questionType}");
    }
  }

  void _previousQuestion() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _nextQuestion() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _submitForm() {
    // TODO: Implement form submission logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form submitted! (Not really)')),
    );
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

