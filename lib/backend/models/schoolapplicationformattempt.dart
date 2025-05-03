import 'dart:convert';

import '../backend.dart';
import '../model.dart';
import 'schoolapplicationform.dart';
import 'session.dart';
import 'user.dart';

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

  Future<void> accept(
    Session session,
    String role,
    List<String> classroomsIds,
    List<String> tags,
    List<String> children,
  ) async {
    final res = await apiQuery("schoolapplicationformattempt/$id/accept", {
      'role': role,
      'classrooms': jsonEncode(classroomsIds),
      'tags': jsonEncode(tags),
      'children': jsonEncode(children),
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
