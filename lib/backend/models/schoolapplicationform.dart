import '../model.dart';

class SchoolApplicationFormQuestion implements Model {
  final int number;
  final String question;
  final String type;
  final bool required;
  const SchoolApplicationFormQuestion({
    required this.number,
    required this.question,
    required this.type,
    required this.required,
  });

  factory SchoolApplicationFormQuestion.fromJson(Map<String, dynamic> json) {
    return SchoolApplicationFormQuestion(
      number: json['number'],
      question: json['question'],
      type: json['type'],
      required: json['required'] ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'question': question,
      'type': type,
      'required': required,
    };
  }
}

class SchoolApplicationForm implements Model {
  final String id;
  final String schoolId;
  final String userId;
  final String status;
  final String description;
  final String title;
  final String instructions;
  final List<SchoolApplicationFormQuestion> questions;
  const SchoolApplicationForm({
    required this.id,
    required this.schoolId,
    required this.title,
    required this.userId,
    required this.status,
    required this.description,
    required this.instructions,
    required this.questions,
  });

  factory SchoolApplicationForm.fromJson(Map<String, dynamic> json) {
    return SchoolApplicationForm(
      id: json['id'],
      title: json['title'],
      schoolId: json['school_id'],
      userId: json['user_id'],
      status: json['status'],
      description: json['description'],
      instructions: json['instructions'],
      questions:
          (json['questions'] as List)
              .map(
                (question) => SchoolApplicationFormQuestion.fromJson(question),
              )
              .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'school_id': schoolId,
      'title': title,
      'user_id': userId,
      'status': status,
      'description': description,
      'instructions': instructions,
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }
}
