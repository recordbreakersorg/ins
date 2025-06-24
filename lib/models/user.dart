import 'package:ins/models/school_user.dart';

import 'model.dart';
import 'package:ins/netimage.dart';
import 'package:ins/backend.dart' as backend;
import 'session.dart';

class User implements Model {
  final int id;
  final String username;
  final String email;
  final String fullname;
  final NetImage? profile;
  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.fullname,
    this.profile,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      fullname: json['fullname'] as String,
      profile: json['profile'] != null
          ? NetImage(url: json['profile'] as String)
          : null,
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "fullname": fullname,
      "profile": profile?.url,
    };
  }

  static Future<User> getByID(Session? session, int id) async {
    final data = await backend.query("v1/user/get", {
      "id": id.toString(),
    }, session);
    if (data["status"] < 0) {
      throw Exception("Failed to get user by ID: ${data["message"]}");
    }
    return User.fromJson(data["user"] as Map<String, dynamic>);
  }

  static Future<UsernameInfo> usernameInfo(String name) async {
    final data = await backend.query("v1/username/info", {
      "username": name,
    }, null);
    if (data['status'] < 0) {
      throw Exception("Failed to check username: ${data['message']}");
    }
    return UsernameInfo.fromJson(data['info'] as Map<String, dynamic>);
  }

  Future<SchoolUser?> getSchoolUserBySchoolID(Session? session, int schoolId) {
    return SchoolUser.getFromIds(session, schoolId, id);
  }

  Future<List<SchoolUser>> getSchoolUsers(Session? session) async {
    final data = await backend.query("v1/user/getchoolusers", {
      "user_id": id,
    }, session);
    if (data['status'] as int < 0) {
      throw "Error getting school users ${data['message'] as String}";
    }
    return (data["users"] as List<Map<String, dynamic>>)
        .map(SchoolUser.fromJson)
        .toList();
  }
}

class UsernameInfo {
  final bool isValid;
  final bool isTaken;
  const UsernameInfo({required this.isValid, required this.isTaken});
  factory UsernameInfo.fromJson(Map<String, dynamic> json) {
    return UsernameInfo(
      isValid: json['is_valid'] as bool,
      isTaken: json['is_taken'] as bool,
    );
  }
}
