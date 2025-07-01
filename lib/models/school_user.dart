import 'package:ins/models/class.dart';

import 'school.dart';
import 'user.dart';
import 'session.dart';
import 'userrole.dart';
import 'model.dart';
import 'package:ins/backend.dart' as backend;

class SchoolUser implements Model {
  final int schoolId;
  final int userId;
  final int? classId;
  final UserRole role;
  const SchoolUser({
    required this.schoolId,
    required this.userId,
    required this.classId,
    required this.role,
  });
  factory SchoolUser.fromJson(Map<String, dynamic> data) {
    return SchoolUser(
      schoolId: data["school_id"] as int,
      userId: data["user_id"] as int,
      classId: data["class_id"] as int?,
      role: (data["role"] as String).toUserRole(),
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      "school_id": schoolId,
      "user_id": userId,
      "class_id": classId,
      "role": role.toJson(),
    };
  }

  Future<School> getSchool(Session? session) {
    return School.getByID(session, schoolId);
  }

  Future<User> getUser(Session? session) {
    return User.getByID(session, userId);
  }

  static Future<SchoolUser?> getFromIds(
    Session? session,
    int schoolId,
    int userId,
  ) async {
    final data = await backend.query("v1/school/getuser", {
      "user_id": userId.toString(),
      "school_id": userId.toString(),
    }, session);
    if ((data["status"] as int) < 0) {
      if ((data["status"] as int) == backend.Status.notFound) {
        return null;
      } else {
        throw data["message"] as String;
      }
    }
    return SchoolUser.fromJson(data["user"] as Map<String, dynamic>);
  }

  Future<Class?> getClass(Session? session) async {
    if (classId == null) return null;
    return await Class.getById(session, classId!);
  }
}
