import '../model.dart';
import './profile.dart';
import '../backend.dart';

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
  final String instructions;
  final List<SchoolApplicationFormQuestion> questions;
  const SchoolApplicationForm({
    required this.id,
    required this.schoolId,
    required this.userId,
    required this.status,
    required this.description,
    required this.instructions,
    required this.questions,
  });

  factory SchoolApplicationForm.fromJson(Map<String, dynamic> json) {
    return SchoolApplicationForm(
      id: json['id'],
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
      'user_id': userId,
      'status': status,
      'description': description,
      'instructions': instructions,
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }
}

class SchoolMember implements Model {
  final String id;
  final String userId;
  final String schoolId;
  const SchoolMember({
    required this.id,
    required this.userId,
    required this.schoolId,
  });

  factory SchoolMember.fromJson(Map<String, dynamic> json) {
    return SchoolMember(
      id: json['id'],
      userId: json['user_id'],
      schoolId: json['school_id'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'user_id': userId, 'school_id': schoolId};
  }
}

class SchoolInfo implements Model {
  final String name;
  final String description;
  final String? address;
  const SchoolInfo({required this.name, this.description = "", this.address});

  @override
  Map<String, dynamic> toJson() {
    return {"name": name, "description": description, "address": address};
  }

  static SchoolInfo fromJson(Map<String, dynamic> json) {
    return SchoolInfo(
      name: json['name'],
      description: json['description'],
      address: json['address'],
    );
  }
}

class School implements Model {
  final String id;
  final String school_name;
  final SchoolInfo info;
  final Profile profile;

  const School({
    required this.id,
    required this.school_name,
    required this.info,
    required this.profile,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      school_name: json['school_name'],
      id: json['id'],
      profile: Profile.fromJson(json['profile']),
      info: SchoolInfo.fromJson(json['info']),
    );
  }

  static Future<List<School>> getSchools() async {
    final res = await cacheableQuery("school/all", "schools", {}, null);
    if (res['status'] < 0) {
      throw Exception(res['message']);
    }
    return res['schools'].map<School>((json) => School.fromJson(json)).toList();
  }

  Future<SchoolApplicationForm?> getApplicationForm() async {
    final res = await cacheableQuery(
      "school/$id/application",
      "school/$id/applicationform",
      {},
      null,
    );
    if (res['status'] < 0) {
      throw Exception(res['message']);
    }
    if (res['status'] == 11) {
      return null;
    }
    return SchoolApplicationForm.fromJson(res['application']);
  }

  Future<bool> hasApplicationForm() async {
    return await getApplicationForm() != null;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'school_name': school_name,
      'info': info.toJson(),
      'profile': profile.toJson(),
    };
  }
}
