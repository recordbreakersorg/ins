import 'dart:convert';

import 'package:ins/backend/backend.dart';

import '../model.dart';
import './profile.dart';
import './session.dart';

class ClassroomMember implements Model {
  final String id;
  final String memberId;
  final String classroomId;

  const ClassroomMember({
    required this.id,
    required this.memberId,
    required this.classroomId,
  });
  factory ClassroomMember.fromJson(Map<String, dynamic> json) {
    return ClassroomMember(
      id: json['id'],
      memberId: json['member_id'],
      classroomId: json['classroom_id'],
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'member_id': memberId, 'classroom_id': classroomId};
  }

  Future<Classroom> getClassroom(Session session) {
    return Classroom.fromId(session, classroomId);
  }
}

class ClassroomInfo implements Model {
  final String name;
  final String description;
  const ClassroomInfo({required this.name, this.description = ""});

  @override
  Map<String, dynamic> toJson() {
    return {'name': name, 'description': description};
  }

  static ClassroomInfo fromJson(Map<String, dynamic> json) {
    return ClassroomInfo(name: json['name'], description: json['description']);
  }
}

class Classroom implements Model {
  final String id;
  final String classroomName;
  final String role;
  final ClassroomInfo info;
  final List<String> tags;
  final Profile profile;
  final String schoolId;

  const Classroom({
    required this.id,
    required this.classroomName,
    required this.role,
    required this.info,
    required this.tags,
    required this.profile,
    required this.schoolId,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'classroom_name': classroomName,
      'role': role,
      'profile': profile.toJson(),
      'school_id': schoolId,
      'tags': tags,
      'info': info.toJson(),
    };
  }

  static Future<Classroom> fromId(Session session, String classroomId) async {
    final response = await cacheableQuery(
      "classroom/$classroomId",
      "classroom/$classroomId",
      {},
      session,
    );
    if (response["status"] >= 0) {
      return Classroom.fromJson(response["classroom"]);
    } else {
      throw Exception(response["message"]);
    }
  }

  factory Classroom.fromJson(Map<String, dynamic> json) {
    var cls = Classroom(
      id: json['id'],
      classroomName: json['classroom_name'],
      role: json['role'],
      info: ClassroomInfo.fromJson(json['info']),
      tags: List<String>.from(json['tags'].map((tag) => tag.toString())),
      profile: Profile.fromJson(json['profile']),
      schoolId: json['school_id'],
    );
    return cls;
  }
}
