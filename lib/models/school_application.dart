import 'package:ins/utils/logger.dart';

import 'model.dart';

enum SchoolApplicationFormQuestionType {
  string,
  select,
  checkbox,
  date,
  int,
  phone,
  email,
  file,
  bool,
}

class SchoolApplicationFormQuestion implements Model {
  final int id;
  final String questionText;
  final SchoolApplicationFormQuestionType questionType;
  final Map<String, dynamic> options;
  final bool required;

  const SchoolApplicationFormQuestion({
    required this.id,
    required this.questionText,
    required this.questionType,
    required this.options,
    required this.required,
  });

  factory SchoolApplicationFormQuestion.fromJson(Map<String, dynamic> data) {
    return SchoolApplicationFormQuestion(
      id: data['id'] as int,
      questionText: data['question_text'] as String,
      questionType: SchoolApplicationFormQuestionType.values.byName(
        data['question_type'] as String,
      ),
      options: data['options'] as Map<String, dynamic>? ?? {},
      required: data['required'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_text': questionText,
      'question_type': questionType.name,
      'options': options,
      'required': required,
    };
  }
}

class SchoolApplicationForm implements Model {
  final int id;
  final int schoolId;
  final String title;
  final String? description;
  final String? instructions;
  final String submittedMessage;
  final List<SchoolApplicationFormQuestion> questions;
  //TODO: add questions
  const SchoolApplicationForm({
    required this.id,
    required this.schoolId,
    required this.title,
    required this.description,
    required this.instructions,
    required this.submittedMessage,
    required this.questions,
  });
  String getInstructions() {
    return instructions ??
        """
# School Application Instructions

Welcome to the school application form. Please read the following instructions carefully before proceeding:

1. **Complete All Fields:** Ensure that you fill in all required fields in the application form. Incomplete applications may not be processed.

2. **Review Your Information:** Before submitting, double-check all the information you have provided. Make sure your details are accurate and reflect your values and intentions.

3. **Submission and Processing:** After submitting your application, it will be reviewed by our school staff. Please note that the review process is handled by real people and may take a variable number of working days.

4. **Notification:** You will be notified of the outcome once a decision has been made. If further information is needed, we may contact you using the details provided.

Thank you for your interest in our school. We look forward to reviewing your application.
""";
  }

  factory SchoolApplicationForm.fromJson(Map<String, dynamic> data) {
    return SchoolApplicationForm(
      id: data['id'] as int,
      schoolId: data['school_id'] as int,
      title: data['title'] as String,
      description: data['description'] as String?,
      instructions: data['instructions'] as String?,
      submittedMessage: data['submitted_message'] as String,
      questions: data['questions'] == null
          ? []
          : (data['questions'] as List)
                .map(
                  (e) => SchoolApplicationFormQuestion.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList(),
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "school_id": schoolId,
      "title": title,
      "description": description,
      "instructions": instructions,
      "submitted_message": submittedMessage,
      "questions": questions.map((e) => e.toJson()).toList(),
    };
  }
}
