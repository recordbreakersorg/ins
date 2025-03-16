import 'package:http/http.dart' as http;
import 'dart:convert';
import 'backend.dart';

abstract class Model {
  Map<String, dynamic> toJson();

  static Model fromJson(Map<String, dynamic> json) {
    throw UnimplementedError(
      'Model.fromJson() must be implemented by subclasses',
    );
  }

  @override
  String toString() {
    return json.encode(toJson());
  }
}

class Session implements Model {
  final String token;
  final String userId;
  final String id;
  // Add additional fields if needed

  Session({required this.id, required this.token, required this.userId});

  static Session fromJson(Map<String, dynamic> json) {
    return Session(
      token: json['token'],
      userId: json['user_id'],
      id: json['id'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'token': token, 'user_id': userId, 'id': id};
  }

  Future<User?> getUser() async {
    final url = Uri.parse("${get_backend_url()}/api/v1/user");
    try {
      final response = await http.get(
        url,
        headers: {'session-id': id, 'session-token': token},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] >= 0) {
          return User.fromJson(data['user']);
        }
        print("Failed to get user: ${data['message']}");
        return null;
      }
      print("Failed to get user: HTTP ${response.statusCode}");
      return null;
    } catch (e) {
      print("An error occurred: $e");
      return null;
    }
  }

  Future<List<Classroom>> getClassrooms() async {
    final url = Uri.parse("${get_backend_url()}/api/v1/user/classrooms");
    try {
      final response = await http.get(
        url,
        headers: {'session-id': id, 'session-token': token},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] >= 0) {
          return data['classrooms']
              .map((json) => Classroom.fromJson(json))
              .toList();
        }
      }
      print("Failed to get classrooms: HTTP ${response.statusCode}");
      return [];
    } catch (e) {
      print("An error occurred: $e");
      return [];
    }
  }
}

class Profile implements Model {
  final String pid;
  final String register;
  final String ext;

  const Profile({required this.pid, required this.register, required this.ext});

  String getPath() {
    return "${get_backend_url()}/profiles/$register/$pid.$ext";
  }

  static Profile fromJson(Map<String, dynamic> json) {
    return Profile(
      pid: json['pid'],
      register: json['register'],
      ext: json['ext'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'pid': pid, 'register': register, 'ext': ext};
  }
}

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
      print("Failed to get school: HTTP ${response.statusCode}");
      return null;
    } catch (e) {
      print("An error occurred: $e");
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

  static Future<User?> get(String id) async {
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
}

class Classroom implements Model {
  final String id;
  final String name;
  final String role;
  final Profile profile;
  final String schoolId;

  const Classroom({
    required this.id,
    required this.name,
    required this.role,
    required this.profile,
    required this.schoolId,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'profile': profile.toJson(),
      'school_id': schoolId,
    };
  }

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      profile: Profile.fromJson(json['profile']),
      schoolId: json['school_id'],
    );
  }

  static Future<Classroom?> get(String id) async {
    final url = Uri.parse("${get_backend_url()}/api/v1/classroom/$id");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] >= 0) {
          return Classroom.fromJson(data['classroom']);
        }
        return null;
      }
      print("Failed to get classroom: HTTP ${response.statusCode}");
      return null;
    } catch (e) {
      print("An error occurred: $e");
      return null;
    }
  }
}
