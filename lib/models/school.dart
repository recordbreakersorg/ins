import 'package:ins/models/school_application.dart';
import 'package:ins/models/school_user.dart';

import 'model.dart';
import 'package:ins/backend.dart' as backend;
import 'session.dart';

class School implements Model {
  final String? logoUrl;
  final String? address;
  final int id;
  final String schoolname;
  final String fullname;
  final String? description;
  final int? chatserverId;
  const School({
    required this.id,
    required this.schoolname,
    required this.fullname,
    required this.description,
    required this.chatserverId,
    this.logoUrl =
        "http://localhost:8123/is.png", //"https://sintranet.vercel.app/is_logo.png",
    this.address = "Somewhere",
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "schoolname": schoolname,
      "fullname": fullname,
      "description": description,
      "chatserver_id": chatserverId,
    };
  }

  factory School.fromJson(Map<String, dynamic> obj) {
    return School(
      id: obj["id"] as int,
      schoolname: obj["schoolname"] as String,
      fullname: obj["fullname"] as String,
      description: obj["description"] as String?,
      chatserverId: obj["chatserver_id"] as int?,
    );
  }

  static Future<School> getByID(Session? session, int id) async {
    final data = await backend.query("school/get", {
      "id": id.toString(),
    }, session);
    if (data["status"] < 0) {
      throw data["message"];
    }
    return School.fromJson(data["school"] as Map<String, dynamic>);
  }

  Future<SchoolUser?> getUserById(Session? session, int userId) {
    return SchoolUser.getFromIds(session, id, userId);
  }

  static Future<List<School>> getAllSchools(
    Session? session,
    int offset,
    int limit,
  ) async {
    final response = await backend.query("v1/school/all", {
      "offset": offset.toString(),
      "limit": limit.toString(),
    }, session);
    if (response['status'] as int < 0) {
      throw Exception(response['message']);
    }
    return response['schools'] != null
        ? (response['schools'] as List<dynamic>)
              .map((school) => School.fromJson(school as Map<String, dynamic>))
              .toList()
        : [];
  }

  double computeRating() {
    return 3.2;
  }

  Future<List<SchoolApplicationForm>> getApplicationForms(
    Session? session,
  ) async {
    final data = await backend.query("v1/school/application/forschool", {
      "school_id": id.toString(),
    }, session);
    if (data['status'] < 0) {
      throw Exception(data['message']);
    }
    return data['forms'] == null
        ? []
        : (data['forms'] as List<dynamic>)
              .map(
                (form) => SchoolApplicationForm.fromJson(
                  form as Map<String, dynamic>,
                ),
              )
              .toList();
  }
}
