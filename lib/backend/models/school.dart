import 'dart:convert';
import 'package:http/http.dart' as http;
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

  static Future<SchoolMember?> fromID(String id) async {
    final url = Uri.parse("${get_backend_url()}/api/v1/school_member/$id");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] >= 0) {
          return SchoolMember.fromJson(data['school_member']);
        }
        return null;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

class SchoolInfo implements Model {
  const SchoolInfo();

  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  static SchoolInfo fromJson(Map<String, dynamic> json) {
    return const SchoolInfo();
  }
}

class School implements Model {
  final String id;
  final String name;
  final SchoolInfo info;
  final Profile profile;

  const School({
    required this.id,
    required this.name,
    required this.info,
    required this.profile,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      name: json['name'],
      id: json['id'],
      profile: Profile.fromJson(json['profile']),
      info: SchoolInfo(),
    );
  }

  static Future<School?> get(String id) async {
    final url = Uri.parse("${get_backend_url()}/api/v1/school/$id");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] >= 0) {
          return School.fromJson(data['school']);
        }
        return null;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'info': info.toJson(),
      'profile': profile.toJson(),
    };
  }
}
