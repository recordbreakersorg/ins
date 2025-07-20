import 'model.dart';
import 'user.dart';
import 'package:ins/backend.dart' as backend;

class Session implements Model {
  final int id;
  final int userId;
  final DateTime createdAt;
  final String token;
  final String fcmToken;
  const Session({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.token,
    required this.fcmToken,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'token': token,
      'fcm-token': fcmToken,
    };
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      token: json['token'] as String,
      fcmToken: json['fcm-token'],
    );
  }
  Future<User> getUser(Session? session) {
    return User.getByID(session, userId);
  }

  Future<Session> updateFCMToken(String fcmToken) async {
    final response = await backend.query("v1/session/fcm-token/update", {
      'fcm-token': fcmToken,
    }, this);
    if (response['status'] < 0) {
      throw Exception(response['message']);
    }
    return Session.fromJson(response['session'] as Map<String, dynamic>);
  }
}
