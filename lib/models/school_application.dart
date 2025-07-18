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
  final int formId;
  final String text;
  final SchoolApplicationFormQuestionType questionType;
  final Map<String, dynamic> options;
  final bool required;

  const SchoolApplicationFormQuestion({
    required this.id,
    required this.formId,
    required this.text,
    required this.questionType,
    required this.options,
    required this.required,
  });

  factory SchoolApplicationFormQuestion.fromJson(Map<String, dynamic> data) {
    return SchoolApplicationFormQuestion(
      id: data['id'] as int,
      formId: data['form_id'] as int,
      text: data['text'] as String,
      questionType: SchoolApplicationFormQuestionType.values.byName(
        data['question_type'] as String,
      ),
      options: data['options'] as Map<String, dynamic>,
      required: data['required'] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'form_id': formId,
      'text': text,
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
