import '../model.dart';
import './profile.dart';
import '../backend.dart';
import './session.dart';
import 'schoolapplicationform.dart';
import 'schoolapplicationformattempt.dart';
import 'schoolmember.dart';
import 'classroom.dart';

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

  Future<List<Classroom>> getClassrooms(Session session) async {
    final res = await cacheableQuery(
      "school/$id/classrooms",
      "school/$id/classrooms",
      {},
      session,
    );
    if (res['status'] < 0) {
      throw Exception(res['message']);
    }
    return (res['classrooms'] as List)
        .map((classroom) => Classroom.fromJson(classroom))
        .toList();
  }
}
