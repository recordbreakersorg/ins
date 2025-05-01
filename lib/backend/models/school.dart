import '../model.dart';
import './profile.dart';
import '../backend.dart';
import './session.dart';
import './user.dart';

enum SchoolMemberRole { student, teacher, admin, parent }

extension SchoolMemberRoleExtension on SchoolMemberRole {
  String toJson() {
    switch (this) {
      case SchoolMemberRole.student:
        return "student";
      case SchoolMemberRole.teacher:
        return "teacher";
      case SchoolMemberRole.admin:
        return "admin";
      case SchoolMemberRole.parent:
        return "parent";
    }
  }
}

extension SchoolMemberRoleStringExtension on String {
  SchoolMemberRole? toSchoolMemberRole() {
    switch (this) {
      case "student":
        return SchoolMemberRole.student;
      case "teacher":
        return SchoolMemberRole.teacher;
      case "admin":
        return SchoolMemberRole.admin;
      case "parent":
        return SchoolMemberRole.parent;
      default:
        return null;
    }
  }
}

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

class SchoolApplicationFormAttemptAnswer implements Model {
  final int questionNumber;
  final String content;
  const SchoolApplicationFormAttemptAnswer({
    required this.questionNumber,
    required this.content,
  });

  @override
  Map<String, dynamic> toJson() {
    return {'question_number': questionNumber, 'content': content};
  }

  factory SchoolApplicationFormAttemptAnswer.fromJson(
    Map<String, dynamic> json,
  ) {
    return SchoolApplicationFormAttemptAnswer(
      questionNumber: json['question_number'],
      content: json['content'],
    );
  }
}

class AttempteeNApplicationForm {
  final User attemptee;
  final SchoolApplicationForm applicationForm;
  const AttempteeNApplicationForm({
    required this.attemptee,
    required this.applicationForm,
  });
}

class SchoolApplicationFormAttempt implements Model {
  final String id;
  final String attempteeId;
  final String applicationId;
  final bool reviewed;
  final bool accepted;
  final List<SchoolApplicationFormAttemptAnswer> answers;
  const SchoolApplicationFormAttempt({
    required this.id,
    required this.attempteeId,
    required this.applicationId,
    required this.answers,
    required this.accepted,
    required this.reviewed,
  });
  factory SchoolApplicationFormAttempt.fromJson(Map<String, dynamic> json) {
    return SchoolApplicationFormAttempt(
      id: json['id'],
      attempteeId: json['attemptee_id'],
      applicationId: json['application_id'],
      accepted: json['accepted'] ?? false,
      reviewed: json['reviewed'] ?? false,
      answers:
          (json['answers'] as List)
              .map(
                (answer) => SchoolApplicationFormAttemptAnswer.fromJson(answer),
              )
              .toList(),
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attemptee_id': attempteeId,
      'application_id': applicationId,
      'answers': answers.map((answer) => answer.toJson()).toList(),
      'accepted': accepted,
      'reviewed': reviewed,
    };
  }

  Future<SchoolApplicationForm> getApplicationForm(Session session) async {
    final res = await cacheableQuery(
      "schoolapplicationform/$applicationId",
      "schoolapplicationform/$applicationId",
      {},
      session,
    );
    if (res['status'] < 0) {
      throw Exception(res['message']);
    }
    return SchoolApplicationForm.fromJson(res['form']);
  }

  Future<void> accept(Session session, String role) async {
    final res = await apiQuery("schoolapplicationformattempt/$id/accept", {
      'role': role,
    }, session);
    if (res['status'] < 0) {
      throw Exception(res['message']);
    }
  }

  Future<void> decline(Session session) async {
    final res = await apiQuery(
      "schoolapplicationformattempt/$id/decline",
      {},
      session,
    );
    if (res['status'] < 0) {
      throw Exception(res['message']);
    }
  }

  Future<User> getAttemptee(Session session) async {
    final res = await cacheableQuery(
      "user/$attempteeId",
      "user/$attempteeId",
      {},
      session,
    );
    if (res['status'] < 0) {
      throw Exception(res['message']);
    }
    return User.fromJson(res['user']);
  }

  Future<AttempteeNApplicationForm> getAttempteeNApplicationForm(
    Session session,
  ) async {
    return AttempteeNApplicationForm(
      attemptee: await getAttemptee(session),
      applicationForm: await getApplicationForm(session),
    );
  }
}

class SchoolMember implements Model {
  final String id;
  final String userId;
  final String schoolId;
  final SchoolMemberRole role;
  const SchoolMember({
    required this.id,
    required this.userId,
    required this.schoolId,
    required this.role,
  });

  factory SchoolMember.fromJson(Map<String, dynamic> json) {
    return SchoolMember(
      id: json['id'],
      userId: json['user_id'],
      schoolId: json['school_id'],
      role:
          json['role'].toString().toSchoolMemberRole() ??
          SchoolMemberRole.student,
    );
  }

  Future<User> getUser(Session session) async {
    final res = await cacheableQuery(
      "user/$userId",
      "user/$userId",
      {},
      session,
    );
    if (res['status'] < 0) {
      throw Exception(res['message']);
    }
    return User.fromJson(res['user']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'user_id': userId, 'school_id': schoolId, 'role': role};
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

  Future<List<SchoolApplicationFormAttempt>> getApplicationAttempts(
    Session session,
  ) async {
    final res = await cacheableQuery(
      "school/$id/applicationattempts",
      "school/$id/applicationattempts",
      {},
      session,
    );
    if (res['status'] < 0) {
      throw Exception(res['message']);
    }
    return (res['attempts'] as List)
        .map((attempt) => SchoolApplicationFormAttempt.fromJson(attempt))
        .toList();
  }

  static Future<List<School>> getSchools() async {
    final res = await cacheableQuery("school/all", "schools", {}, null);
    if (res['status'] < 0) {
      throw Exception(res['message']);
    }
    return res['schools'].map<School>((json) => School.fromJson(json)).toList();
  }

  Future<SchoolMember> getMember(Session session) async {
    final response = await cacheableQuery(
      "school/$id/member",
      "school/$id/member",
      {},
      session,
    );
    if (response['status'] < 0) throw Exception(response['message']);
    return SchoolMember.fromJson(response['member']);
  }

  Future<List<SchoolMember>> getMembers(Session session) async {
    final response = await cacheableQuery(
      "school/$id/members",
      "school/$id/members",
      {},
      session,
    );
    if (response['status'] < 0) throw Exception(response['message']);
    return (response['members'] as List)
        .map((member) => SchoolMember.fromJson(member))
        .toList();
  }

  Future<List<SchoolApplicationForm>> getApplicationForms() async {
    try {
      final res = await cacheableQuery(
        "school/$id/applications",
        "school/$id/applicationforms",
        {},
        null,
      );
      if (res['status'] < 0) {
        throw Exception(res['message']);
      }
      if (res['status'] == 11) {
        return [];
      }
      return ((res['applications'] as List).map(
        (application) => SchoolApplicationForm.fromJson(application),
      )).toList();
    } catch (e) {
      print(e);
      return [];
    }
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
