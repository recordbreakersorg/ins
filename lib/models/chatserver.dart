import 'model.dart';
import 'session.dart';
import 'package:ins/backend.dart' as backend;

class Chatserver implements Model {
  final int id;
  final String fullname;
  const Chatserver({required this.id, required this.fullname});
  @override
  Map<String, dynamic> toJson() {
    return {"id": id, "fullname": fullname};
  }

  factory Chatserver.fromJson(Map<String, dynamic> data) {
    return Chatserver(
      id: data['id'] as int,
      fullname: data['schoolname'] as String,
    );
  }
  static Future<Chatserver> getById(Session? session, int id) async {
    final data = await backend.query("v1/chatserver/get", {
      "id": id.toString(),
    }, session);
    if (data['status'] as int < 0) {
      throw "Error getting charserver $id: ${data['message'] as String}";
    }
    return Chatserver.fromJson(data['server'] as Map<String, dynamic>);
  }
}
