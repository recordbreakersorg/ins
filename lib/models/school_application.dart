import 'model.dart';

class SchoolApplicationForm implements Model {
  final int id;
  final int schoolId;
  final String title;
  final String? description;
  final String? instructions;
  final String submittedMessage;
  //TODO: add questions
  const SchoolApplicationForm({
    required this.id,
    required this.schoolId,
    required this.title,
    required this.description,
    required this.instructions,
    required this.submittedMessage,
  });
  factory SchoolApplicationForm.fromJson(Map<String, dynamic> data) {
    return SchoolApplicationForm(
      id: data['id'] as int,
      schoolId: data['school_id'] as int,
      title: data['title'] as String,
      description: data['description'] as String?,
      instructions: data['instructions'] as String?,
      submittedMessage: data['submitted_message'] as String,
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
    };
  }
}
