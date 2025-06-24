import 'chatserver.dart';

import 'model.dart';
import 'session.dart';
import 'package:ins/backend.dart' as backend;
import 'thread.dart';

class Chatroom implements Model {
  final int id;
  final String title;
  final String? description;
  final int? serverId;
  final int? threadId;
  final DateTime createdAt;
  const Chatroom({
    required this.id,
    required this.title,
    required this.description,
    required this.serverId,
    required this.threadId,
    required this.createdAt,
  });
  factory Chatroom.fromJson(Map<String, dynamic> data) {
    return Chatroom(
      id: data['id'] as int,
      title: data['title'] as String,
      description: data['description'] as String?,
      serverId: data['server_id'] as int?,
      threadId: data['thread_id'] as int?,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "server_id": serverId,
      "thread_id": threadId,
      "created_at": createdAt.toIso8601String(),
    };
  }

  static Future<Chatroom> getById(Session? session, int id) async {
    final data = await backend.query("v1/chatroom/get", {"id": id}, session);
    if (data['status'] as int < 0) {
      throw "Error getting chatroom $id: ${data['message'] as String}";
    }
    return Chatroom.fromJson(data['room'] as Map<String, dynamic>);
  }

  Future<Chatserver?> getServer(Session? session) async {
    if (serverId == null) return null;
    return Chatserver.getById(session, serverId!);
  }

  Future<Thread?> getThread(Session? session) async {
    if (threadId == null) return null;
    return Thread.getByID(session, threadId!);
  }
}
