import '../backend.dart';
import '../model.dart';
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

  Future<List<SchoolMember>> getTutoring(Session session) async {
    final res = await cacheableQuery(
      "schoolmember/$id/tutoring",
      "schoolmember/$id/tutoring",
      {},
      session,
    );
    if (res['status'] < 0) {
      throw Exception(res['message']);
    }
    return (res['tutoring'] as List)
        .map((t) => SchoolMember.fromJson(t))
        .toList();
  }

  Future<List<SchoolMemberNUser>> getTutoringNUsers(Session session) async {
    final tutorings = await getTutoring(session);
    List<SchoolMemberNUser> mnu = [];
    for (final tutoring in tutorings) {
      final user = await tutoring.getUser(session);
      mnu.add(SchoolMemberNUser(user: user, member: tutoring));
    }
    return mnu;
  }
}

class SchoolMemberNUser {
  final SchoolMember member;
  final User user;
  const SchoolMemberNUser({required this.user, required this.member});
}
