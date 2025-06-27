import 'package:ins/models/school_user.dart';

import 'model.dart';
import 'package:ins/netimage.dart';
import 'package:ins/backend.dart' as backend;
import 'session.dart';

class User implements Model {
  final int id;
  final String username;
  final String? email;
  final String fullname;
  final String? profilePicture;
  final String? phone;
  final bool phoneVerified;
  final bool emailVerified;
  final DateTime? birthdate;
  final DateTime? joinedDate;
  final String? bio;
  final Map<String, dynamic> socialLinks;
  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.emailVerified,
    required this.phone,
    required this.phoneVerified,
    required this.fullname,
    required this.birthdate,
    required this.joinedDate,
    required this.profilePicture,
    required this.bio,
    required this.socialLinks,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String?,
      emailVerified: json['email_verified'] as bool,
      fullname: json['fullname'] as String,
      phone: json['phone'] as String?,
      phoneVerified: json['phone_verified'] as bool,
      profilePicture: json['profile_picture'] as String?,
      birthdate: DateTime.tryParse(json['birthdate'] as String? ?? ""),
      joinedDate: DateTime.tryParse(json['joined_date'] as String),
      socialLinks: json['social_links'] as Map<String, dynamic>? ?? {},
      bio: json['bio'] as String?,
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "email_verified": emailVerified,
      "fullname": fullname,
      "phone": phone,
      "phone_verified": phoneVerified,
      "birthdate": birthdate?.toIso8601String(),
      "joined_date": joinedDate?.toIso8601String(),
      "profile_picture": profilePicture,
      "bio": bio,
      "social_links": socialLinks,
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
