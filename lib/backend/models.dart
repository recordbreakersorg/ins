import 'package:http/http.dart' as http;
import 'dart:convert';
import 'backend.dart';

class Session {
  final String token;
  final String userId;
  final String id;
  // Add additional fields if needed

  Session({required this.id, required this.token, required this.userId});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      token: json['token'],
      userId: json['user_id'],
      id: json['id']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user_id': userId,
      'id': id,
    };
  }
  Future<User?> getUser() async {
    final url = Uri.parse("${get_backend_url()}/api/v1/user");
    try {
      final response = await http.get(url, headers: {
        'session-id': id,
        'session-token': token,
      });
      if(response.statusCode == 200) {
        print("Good status");
        final data = json.decode(response.body);
        if(data['status'] >= 0) {
          print("Got user: ${data['user']}");
          return User.fromJson(data['user']);
        } else {
          print("Failed to get user: ${data['message']}");
          return null;
        }
      }
    } catch (e) {
      print("An error occurred: $e");
      return null;
    }
    print("Failed to get user");
    return null;
  }
}

class Profile {
  final String pid;
  final String register;
  Profile({required this.pid, required this.register});
}

class UserContact {
  final String? email;
  final String? phone;
  UserContact({this.email, this.phone});
}
class User {
  final String name;
  final String id;
  final String schoolId;
  final Profile profile;
  final UserContact contact;
  User({required this.name, required this.id, required this.schoolId, required this.profile, required this.contact});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      id: json['id'],
      schoolId: json['school_id'],
      profile: Profile(pid: json['profile']['pid'], register: json['profile']['register']),
      contact: UserContact(email: json['contact']['email'], phone: json['contact']['phone']),
    );
  }
}