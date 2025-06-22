import 'model.dart';
import 'package:ins/netimage.dart';
import 'package:ins/backend.dart' as backend;

class User extends Model {
  final int id;
  final String username;
  final String email;
  final String fullname;
  final NetImage? profile;
  User({
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

  static Future<User> getByID(int id) async {
    final data = await backend.query("user/get", {"id": id.toString()}, null);
    if (data["status"] < 0) {
      throw Exception("Failed to get user by ID: ${data["message"]}");
    }
    return User.fromJson(data["user"] as Map<String, dynamic>);
  }
}
