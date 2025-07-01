import 'package:ins/models.dart';

import 'school_user.dart';
import 'package:ins/backend.dart' as backend;

import 'model.dart';

class Class implements Model {
  final int id;
  final int schoolId;
  final String fullname;
  final int? chatserverId;
  final String? description;
  final DateTime createdAt;
  const Class({
    required this.id,
    required this.schoolId,
    required this.fullname,
    required this.chatserverId,
    required this.description,
    required this.createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "school_id": schoolId,
      "fullname": fullname,
      "chatserver_id": chatserverId,
      "description": description,
      "created_at": createdAt,
    };
  }

  factory Class.fromJson(Map<String, dynamic> data) {
    return Class(
      id: data['id'] as int,
      schoolId: data['school_id'] as int,
      fullname: data['schoolname'] as String,
      chatserverId: data['schoolserver_id'] as int?,
      description: data['description'] as String?,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }
  static Future<Class> getById(Session? session, int id) async {
    final data = await backend.query("v1/class/get", {
      "id": id.toString(),
    }, session);
    if (data['status'] as int < 0) {
      throw "Error fetching class with id $id: ${data['message'] as String}";
    }
    return Class.fromJson(data['class']);
  }

  Future<List<SchoolUser>> getMembers(Session? session) async {
    final data = await backend.query("v1/class/getmembers", {
      "class_id": id.toString(),
    }, session);
    if (data['status'] as int < 0) {
      throw "Error getting members of '$fullname', ${data['message'] as String}";
    }
    return (data["users"] as List<Map<String, dynamic>>)
        .map(SchoolUser.fromJson)
        .toList();
  }

  Future<School> getSchool(Session? session) {
    return School.getByID(session, schoolId);
  }
}
