import 'dart:convert';
import 'package:http/http.dart' as http;
import '../backend.dart';
import '../model.dart';
import './profile.dart';
import './school.dart';

class UserContact implements Model {
  final String? email;
  final String? phone;

  UserContact({this.email, this.phone});

  @override
  Map<String, dynamic> toJson() {
    return {'email': email, 'phone': phone};
  }

  static UserContact fromJson(Map<String, dynamic> json) {
    return UserContact(email: json['email'], phone: json['phone']);
  }
}

class User implements Model {
  final String name;
  final String id;
  final String schoolId;
  final Profile profile;
  final UserContact contact;
  final String role;

  User({
    required this.name,
    required this.id,
    required this.schoolId,
    required this.profile,
    required this.contact,
    required this.role,
  });

  Future<School?> getSchool() async {
    return School.get(schoolId);
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      id: json['id'],
      schoolId: json['school_id'],
      profile: Profile.fromJson(json['profile']),
      contact: UserContact.fromJson(json['contact']),
      role: json['role'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'school_id': schoolId,
      'profile': profile.toJson(),
      'contact': contact.toJson(),
      'role': role,
    };
  }

  static Future<User?> fromId(String id) async {
    final url = Uri.parse("${get_backend_url()}/api/v1/user/$id");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] >= 0) {
          return User.fromJson(data['user']);
        }
        return null;
      }
      print("Failed to get user: HTTP ${response.statusCode}");
      return null;
    } catch (e) {
      print("An error occurred: $e");
      return null;
    }
  }

  static Future<User> create(
    String username,
    String name,
    String password,
    String role,
    DateTime dob,
  ) async {
    Uri url = Uri.parse("${get_backend_url()}/api/v1/user/create");
    final queryParams = {
      'username': username,
      'name': name,
      'password': password,
      'role': role,
      'dob': dob.toIso8601String(),
    };
    url = url.replace(queryParameters: queryParams);

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] >= 0) {
          return User.fromJson(data['user']);
        }
        throw Exception("Failed to create user: ${data['message']}");
      } else {
        throw Exception("Failed to create user: HTTP ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("An error occurred: $e");
    }
  }
}
