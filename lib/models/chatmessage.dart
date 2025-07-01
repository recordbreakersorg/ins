import 'model.dart';
import 'thread.dart';
import 'user.dart';
import 'session.dart';
import 'package:ins/backend.dart' as backend;

class Chatmessage implements Model {
  final int id;
  final int threadId;
  final int userId;
  final String content;
  final DateTime createdAt;
  final DateTime? editedAt;
  final Map<int, String> reactions;
  final int? repliesTo;
  final int? repliesThread;
  const Chatmessage({
    required this.id,
    required this.threadId,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.editedAt,
    required this.reactions,
    required this.repliesTo,
    required this.repliesThread,
  });
  factory Chatmessage.fromJson(Map<String, dynamic> data) {
    return Chatmessage(
      id: data['id'] as int,
      threadId: data['thread_id'] as int,
      userId: data['user_id'] as int,
      content: data['content'] as String,
      createdAt: DateTime.parse(data['created_at'] as String),
      editedAt:
          data['edited_at'] == null
              ? null
              : DateTime.parse(data['edited_at'] as String),
      reactions: data['reactions'] as Map<int, String>,
      repliesTo: data['replies_to'] as int?,
      repliesThread: data['replies_thread'] as int?,
    );
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "thread_id": threadId,
      "user_id": userId,
      "content": content,
      "created_at": createdAt.toIso8601String(),
      "edited_at": editedAt?.toIso8601String(),
      "reactions": reactions,
      "replies_to": repliesTo,
      "replies_thread": repliesThread,
    };
  }

  Future<Thread> getThread(Session? session) {
    return Thread.getByID(session, threadId);
  }

  Future<User> getUser(Session? session) {
    return User.getByID(session, userId);
  }

  Future<Thread?> getRepliesThread(Session? session) async {
    if (repliesThread == null) return null;
    return await Thread.getByID(session, repliesThread!);
  }
}
