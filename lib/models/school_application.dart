import 'model.dart';

class SchoolApplicationForm implements Model {
  final int id;
  final int schoolId;
  final String title;
  final String? description;
  final String? instructions;
  final bool autoaccept;
  final Map<String, dynamic> autoacceptParams;
  final String submittedMessage;
  final DateTime createdAt;
  const SchoolApplicationForm({
    required this.id,
    required this.schoolId,
    required this.title,
    required this.description,
    required this.instructions,
    required this.autoaccept,
    required this.autoacceptParams,
    required this.submittedMessage,
    required this.createdAt,
  });
  factory SchoolApplicationForm.fromJson(Map<String, dynamic> data) {
    return SchoolApplicationForm(
      id: data['id'] as int,
      schoolId: data['school_id'] as int,
      title: data['title'] as String,
      description: data['description'] as String?,
      instructions: data['instructions'] as String?,
      autoaccept: data['autoaccept'] as bool,
      autoacceptParams: data['autoaccept_params'] as Map<String, dynamic>,
      submittedMessage: data['submitted_message'] as String,
      createdAt: DateTime.tryParse(data['created_at']) ?? DateTime.now(),
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
      "autoaccept": autoaccept,
      "autoaccept_params": autoacceptParams,
      "submitted_message": submittedMessage,
      "created_at": createdAt.toIso8601String(),
    };
  }
}
