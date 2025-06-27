import 'model.dart';
import 'user.dart';

class Session implements Model {
  final int id;
  final int userId;
  final DateTime createdAt;
  final String token;
  const Session({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.token,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'token': token,
    };
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      token: json['token'] as String,
    );
  }
  Future<User> getUser(Session? session) {
    return User.getByID(session, userId);
  }
}
