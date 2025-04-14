import 'dart:convert';
import 'package:http/http.dart' as http;
import '../backend.dart';
import '../model.dart';
import './profile.dart';

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

class UserInfo implements Model {
  final String name;
  final String role;
  final DateTime birth;
  const UserInfo({required this.name, required this.role, required this.birth});
  @override
  Map<String, dynamic> toJson() {
    return {'name': name, 'role': role, 'birth': birth.toIso8601String()};
  }

  static UserInfo fromJson(Map<String, dynamic> json) {
    return UserInfo(
      name: json['name'],
      role: json['role'],
      birth: DateTime.parse(json['birth']),
    );
  }
}

class User implements Model {
  final String username;
  final String id;
  final Profile? profile;
  final UserContact contact;
  final UserInfo info;

  User({
    required this.username,
    required this.id,
    required this.profile,
    required this.contact,
    required this.info,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      id: json['id'],
      profile:
          json['profile'] != null ? Profile.fromJson(json['profile']) : null,
      contact: UserContact.fromJson(json['contact']),
      info: UserInfo.fromJson(json['info']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'id': id,
      'profile': profile?.toJson(),
      'contact': contact.toJson(),
      'info': info.toJson(),
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
    late http.Response response;
    try {
      response = await apiRequest("user/create", <String, String>{
        'name': name,
        'password': password,
        'username': username,
        "role": role,
        "dob": dob.toIso8601String(),
      }, null);
    } catch (e) {
      throw Exception(
        "An error occurred please check your internet connection: $e",
      );
    }
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Got data $data");
      if (data['status'] >= 0) {
        return User.fromJson(data['user']);
      }
      throw Exception("Failed to create user: ${data['message']}");
    } else {
      throw Exception("Failed to create user server error.");
    }
  }
}
