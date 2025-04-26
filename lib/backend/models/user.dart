import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ins/backend/sessions.dart';
import '../backend.dart';
import '../model.dart';
import './session.dart';
import './profile.dart';
import './classroom.dart';
import './school.dart';

class UserFeed implements Model {
  final String id;
  final String feedType;
  final String content;
  final String title;
  final String? imagePath;
  final String? link;
  final Map<String, dynamic> data;
  final DateTime created;
  final bool dismissed;

  UserFeed({
    required this.id,
    required this.content,
    required this.feedType,
    required this.data,
    required this.created,
    required this.title,
    required this.dismissed,
    this.imagePath,
    this.link,
  });
  Future<void> dismiss(Session session) async {
    final response = await apiQuery("user/feed/$id/dismiss", {}, session);
    if (response['status'] < 0) {
      throw Exception("Failed to dismiss feed: ${response['message']}");
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'feed_type': feedType,
      'data': data,
      'created': created.toIso8601String(),
      'title': title,
      'image_path': imagePath,
      'link': link,
      'dismissed': dismissed,
    };
  }

  static UserFeed fromJson(Map<String, dynamic> json) {
    return UserFeed(
      id: json['id'],
      content: json['content'],
      feedType: json['feed_type'],
      data: json['data'],
      created: DateTime.parse(json['created']),
      imagePath: json['image_path'],
      link: json['link'],
      title: json['title'],
      dismissed: json['dismissed'] ?? false,
    );
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

  Future<Session> setNewSession(String password) async {
    final response = await apiQuery("session/create", <String, String>{
      'username': username,
      'password': password,
    }, null);
    if (response['status'] < 0) {
      throw Exception("Failed to create session: ${response['message']}");
    }
    final session = Session.fromJson(response['session']);
    await sessionManager.setSession(session);
    return session;
  }

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

  static Future<bool> usernameExists(String username) async {
    final query = await apiQuery('usernameexists', {
      'username': username,
    }, null);
    if (query['status'] == -2) {
      return false;
    } else if (query['status'] == 0) {
      return true;
    } else if (query['status'] < 0) {
      throw Exception("Failed to check username: ${query['message']}");
    } else {
      throw Exception("Wrong status code");
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

  Future<List<Classroom>> getClassrooms(Session session) async {
    final data = await cacheableQuery(
      "user/$id/classrooms",
      "user/classrooms",
      {},
      session,
    );
    if (data['status'] < 0) {
      throw Exception("Error geting to your classrooms");
    }
    if (data['classrooms'] == null) return [];
    return (data['classrooms'] as List)
        .map(
          (classroom) => Classroom.fromJson(classroom as Map<String, dynamic>),
        )
        .toList();
  }

  Future<List<School>> getSchools(Session session) async {
    final data = await cacheableQuery(
      "user/$id/schools",
      "user/schools",
      {},
      session,
    );
    if (data['status'] < 0) {
      throw Exception("Error geting to your classrooms");
    }
    if (data['schools'] == null) return [];
    return (data['schools'] as List)
        .map((school) => School.fromJson(school as Map<String, dynamic>))
        .toList();
  }

  Future<List<UserFeed>> getFeeds(Session session) async {
    final data = await cacheableQuery(
      "user/$id/feeds",
      "user/feeds",
      {},
      session,
    );
    if (data['status'] < 0) {
      throw Exception("Error geting to your feeds");
    }
    if (data['feeds'] == null) return [];
    return (data['feeds'] as List)
        .map((feed) => UserFeed.fromJson(feed as Map<String, dynamic>))
        .toList();
  }
}
