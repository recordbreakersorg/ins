import 'package:ins/models/chatmessage.dart';

import 'model.dart';
import 'session.dart';
import 'package:ins/backend.dart' as backend;

class Thread implements Model {
  final int id;
  final int? parentThreadId;
  const Thread({required this.id, required this.parentThreadId});
  factory Thread.fromJson(Map<String, dynamic> data) {
    return Thread(
      id: data['id'] as int,
      parentThreadId: data['parent_thread_id'] as int?,
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {"id": id, "parent_thread_id": parentThreadId};
  }

  static Future<Thread> getByID(Session? session, int id) async {
    final data = await backend.query("v1/thread/get", {
      "id": id.toString(),
    }, session);
    if (data["status"] < 0) {
      throw Exception("Failed to get chat thread by ID: ${data["message"]}");
    }
    return Thread.fromJson(data["thread"] as Map<String, dynamic>);
  }

  Future<Thread?> getParent(Session? session) async {
    if (parentThreadId == null) return null;
    return await Thread.getByID(session, parentThreadId!);
  }

  Future<Chatmessage> sendMessage(
    Session? session,
    String content,
    int? repliesTo,
  ) async {
    final response = await backend.query("v1/message/send", {
      "content": content,
      "thread_id": id,
      if (repliesTo != null) ...{"replies_to": repliesTo.toString()},
    }, session);
    if (response['status'] as int < 0) {
      throw Exception(
        "Error sending message: ${response['message'] as String}",
      );
    }
    return Chatmessage.fromJson(response['message'] as Map<String, dynamic>);
  }
}
