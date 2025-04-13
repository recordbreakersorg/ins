import '../model.dart';
import '../backend.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './user.dart';
import './classroom.dart';
import './school.dart';

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
      print({'session-id': id, 'session-token': token});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        if (data['status'] >= 0) {
          print("Got the classrooms: ${data['classrooms']}");
          return (data['classrooms'] as List)
              .map((json) => Classroom.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          print("Invalid return status getting classrooms");
          return List<Classroom>.empty();
        }
      } else {
        print("Failed to get classrooms: HTTP ${response.statusCode}");
        return List<Classroom>.empty();
      }
    } catch (e) {
      print("An error occurred: $e");
      return List<Classroom>.empty();
    }
  }
}
