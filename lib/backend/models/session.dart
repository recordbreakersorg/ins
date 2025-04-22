import '../model.dart';
import '../backend.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './user.dart';
import './classroom.dart';

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

  Future<User> getUser() async {
    final data = await apiQuery("user", {}, this);
    if (data['status'] >= 0) {
      return User.fromJson(data['user']);
    } else {
      throw Exception("Could not find your user login session, sorry");
    }
  }
}
