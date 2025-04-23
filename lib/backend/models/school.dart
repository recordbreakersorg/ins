import '../model.dart';
import './profile.dart';
import '../backend.dart';

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
  const SchoolInfo({required this.name});

  @override
  Map<String, dynamic> toJson() {
    return {"name": name};
  }

  static SchoolInfo fromJson(Map<String, dynamic> json) {
    return SchoolInfo(name: json['name']);
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
