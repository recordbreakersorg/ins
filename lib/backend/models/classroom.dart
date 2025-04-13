import '../model.dart';
import './session.dart';
import 'package:http/http.dart' as http;
import '../backend.dart';
import './user.dart';
import './profile.dart';
import 'dart:convert';
import './chatroom.dart';

class ClassroomMember implements Model {
  final String id;
  final String memberId;
  final String classroomId;

  const ClassroomMember({
    required this.id,
    required this.memberId,
    required this.classroomId,
  });
  factory ClassroomMember.fromJson(Map<String, dynamic> json) {
    return ClassroomMember(
      id: json['id'],
      memberId: json['member_id'],
      classroomId: json['classroom_id'],
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'member_id': memberId, 'classroom_id': classroomId};
  }

  static Future<ClassroomMember?> get(String id) async {
    final url = Uri.parse("${get_backend_url()}/api/v1/classroom_member/$id");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] >= 0) {
          return ClassroomMember.fromJson(data['classroom_member']);
        }
        return null;
      }
      print("Failed to get classroom member: HTTP ${response.statusCode}");
      return null;
    } catch (e) {
      print("An error occurred: $e");
      return null;
    }
  }

  Future<User?> getUser() async {
    final url = Uri.parse("${get_backend_url()}/api/v1/user/$memberId");
    try {
      final response = await http.get(url);
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

  Future<Classroom?> getClassroom() async {
    final url = Uri.parse("${get_backend_url()}/api/v1/classroom/$classroomId");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] >= 0) {
          return Classroom.fromJson(data['classroom']);
        }
        print("Failed to get classroom: ${data['message']}");
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
    var cls = Classroom(
      id: json['id'],
      name: json['name'],
      role: json['role'],
      profile: Profile.fromJson(json['profile']),
      schoolId: json['school_id'],
    );
    return cls;
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
      return null;
    } catch (e) {
      print("An error occurred getting classroom $id: $e");
      return null;
    }
  }

  Future<List<Chatroom>> getChatrooms(Session session) async {
    final url = Uri.parse(
      "${get_backend_url()}/api/v1/classroom/$id/chatrooms",
    );
    try {
      final response = await http.get(
        url,
        headers: {'session-id': session.id, 'session-token': session.token},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] >= 0) {
          return (data['chatrooms'] as List)
              .map((json) => Chatroom.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          print("Invalid return status getting chatrooms");
          return List<Chatroom>.empty();
        }
      } else {
        print("Failed to get chatrooms: HTTP ${response.statusCode}");
        return List<Chatroom>.empty();
      }
    } catch (e) {
      print("An error occurred getting chatrooms: $e");
      return List<Chatroom>.empty();
    }
  }
}
