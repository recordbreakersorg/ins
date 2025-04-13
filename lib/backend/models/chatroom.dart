import '../model.dart';
import 'package:http/http.dart' as http;
import './session.dart';
import '../backend.dart';
import 'dart:convert';

class ChatThread extends Model {
  final String id;
  ChatThread({required this.id});
  factory ChatThread.fromJson(Map<String, dynamic> json) {
    return ChatThread(id: json['id']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'id': id};
  }

  Future<List<ChatMessage>> getMessages(Session session) async {
    final url = Uri.parse("${get_backend_url()}/api/v1/thread/$id/messages");
    try {
      final response = await http.get(
        url,
        headers: {'session-id': session.id, 'session-token': session.token},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] >= 0) {
          return (data['messages'] as List)
              .map((json) => ChatMessage.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          print("Invalid return status getting messages");
          return List<ChatMessage>.empty();
        }
      } else {
        print("Failed to get messages: HTTP ${response.statusCode}");
        return List<ChatMessage>.empty();
      }
    } catch (e) {
      print("An error occurred getting messages: $e");
      return List<ChatMessage>.empty();
    }
  }

  Future<bool> sendMessage(Session session, String content) async {
    final url = Uri.http(
      get_backend_base(),
      "/api/v1/thread/$id/message/send",
      {"content": content, "chatroom_id": id},
    );
    try {
      final response = await http.get(
        url,
        headers: {'session-id': session.id, 'session-token': session.token},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] >= 0) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

class Chatroom extends Model {
  final String id;
  final String name;
  final String classroomId;
  final String type;
  final String description;
  final String threadId;
  Chatroom({
    required this.id,
    required this.name,
    required this.classroomId,
    required this.type,
    required this.description,
    required this.threadId,
  });
  factory Chatroom.fromJson(Map<String, dynamic> json) {
    return Chatroom(
      id: json['id'],
      name: json['name'],
      classroomId: json['classroom_id'],
      type: json['type'],
      description: json['description'],
      threadId: json['thread_id'],
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
      'thread_id': threadId,
    };
  }

  Future<ChatThread> getThread(Session session) async {
    final url = Uri.parse("${get_backend_url()}/api/v1/thread/$threadId");
    try {
      final response = await http.get(
        url,
        headers: {'session-id': session.id, 'session-token': session.token},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] >= 0) {
          return ChatThread.fromJson(data['thread']);
        } else {
          throw Exception("Invalid return status when fetching thread.");
        }
      } else {
        throw Exception("Failed to fetch thread: HTTP ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("An error occurred while fetching thread: $e");
    }
  }
}

class ChatMessage extends Model {
  final String id;
  final String content;
  final String senderId;
  final String threadId;
  final String? childThreadID;
  final DateTime sent;
  ChatMessage({
    required this.id,
    required this.content,
    required this.senderId,
    required this.threadId,
    required this.sent,
    required this.childThreadID,
  });
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      content: json['content'],
      senderId: json['sender_id'],
      threadId: json['thread_id'],
      sent: DateTime.parse(json['sent']),
      childThreadID: json['child_thread_id'],
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender_id': senderId,
      'thread_id': threadId,
      'sent': sent.toIso8601String(),
      'child_thread_id': childThreadID,
    };
  }
}
