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
    print("creating classroom, from: $json");
    var cls = Classroom(
      id: json['id'],
      name: json['name'],
      //tags: json['tags'],
      role: json['role'],
      profile: Profile.fromJson(json['profile']),
      schoolId: json['school_id'],
    );
    print("Created");
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
      print("Failed to get classroom: HTTP ${response.statusCode}");
      return null;
    } catch (e) {
      print("An error occurred: $e");
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
          print("Got the chatrooms: ${data['chatrooms']}");
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
      print("An error occurred: $e");
      return List<Chatroom>.empty();
    }
  }
}

class Chatroom extends Model {
  final String id;
  final String name;
  final String classroomId;
  final String type;
  final String description;
  Chatroom({
    required this.id,
    required this.name,
    required this.classroomId,
    required this.type,
    required this.description,
  });
  factory Chatroom.fromJson(Map<String, dynamic> json) {
    return Chatroom(
      id: json['id'],
      name: json['name'],
      classroomId: json['classroom_id'],
      type: json['type'],
      description: json['description'],
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'classroom_id': classroomId,
      'type': type,
      'description': description,
    };
  }

  Future<List<ChatMessage>> getMessages(Session session) async {
    final url = Uri.parse("${get_backend_url()}/api/v1/chatroom/$id/messages");
    try {
      final response = await http.get(
        url,
        headers: {'session-id': session.id, 'session-token': session.token},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] >= 0) {
          print("Got the messages: ${data['messages']}");
          return (data['messages'] as List)
              .map((json) => ChatMessage.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          print("Invalid return status getting chatrooms");
          return List<ChatMessage>.empty();
        }
      } else {
        print("Failed to get chatrooms: HTTP ${response.statusCode}");
        return List<ChatMessage>.empty();
      }
    } catch (e) {
      print("An error occurred: $e");
      return List<ChatMessage>.empty();
    }
  }

  Future<bool> sendMessage(Session session, String content) async {
    final url = Uri.http(
      get_backend_base(),
      "/api/v1/chatroom/$id/message/send",
      {"content": content, "chatroom_id": id},
    );
    try {
      final response = await http.get(
        url,
        headers: {'session-id': session.id, 'session-token': session.token},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("----------;;;;;;${data}");
        if (data['status'] >= 0) {
          return true;
        } else {
          return false;
        }
      } else {
        print("Failed to send message: HTTP ${response.statusCode}");
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

class ChatMessage extends Model {
  final String id;
  final String content;
  final String senderId;
  final String chatroomId;
  final DateTime sent;
  ChatMessage({
    required this.id,
    required this.content,
    required this.senderId,
    required this.chatroomId,
    required this.sent,
  });
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      senderId: json['sender_id'],
      chatroomId: json['chatroom_id'],
      sent: DateTime.parse(json['sent']),
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender_id': senderId,
      'chatroom_id': chatroomId,
      'sent': sent.toIso8601String(),
    };
  }
}
