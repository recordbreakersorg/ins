import '../model.dart';

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
