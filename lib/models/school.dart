import 'package:ins/models/school_user.dart';

import 'model.dart';
import 'package:ins/backend.dart' as backend;
import 'session.dart';

class School implements Model {
  final int id;
  final String schoolname;
  final String fullname;
  final String? description;
  final int? chatserverId;
  const School({
    required this.id,
    required this.schoolname,
    required this.fullname,
    required this.description,
    required this.chatserverId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "schoolname": schoolname,
      "fullname": fullname,
      "description": description,
      "chatserver_id": chatserverId,
    };
  }

  factory School.fromJson(Map<String, dynamic> obj) {
    return School(
      id: obj["id"] as int,
      schoolname: obj["schoolname"] as String,
      fullname: obj["fullname"] as String,
      description: obj["description"] as String?,
      chatserverId: obj["chatserver_id"] as int?,
    );
  }

  static Future<School> getByID(Session? session, int id) async {
    final data = await backend.query("school/get", {"id": id}, session);
    if (data["status"] < 0) {
      throw data["message"];
    }
    return School.fromJson(data["school"] as Map<String, dynamic>);
  }

  Future<SchoolUser?> getUserById(Session? session, int userId) {
    return SchoolUser.getFromIds(session, id, userId);
  }
}
