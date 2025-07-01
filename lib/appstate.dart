import 'package:ins/models.dart' as models;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

const appStateKey = "app-state";

class AppState {
  models.Session? session;
  models.User? user;
  models.SchoolUser? schoolUser;
  models.School? school;
  AppState({this.session, this.user, this.schoolUser, this.school});
  static Future<AppState> load() async {
    final prefs = await SharedPreferences.getInstance();
    final appStateJson = prefs.getString(appStateKey);
    if (appStateJson != null) {
      final dynamic jsonData = json.decode(appStateJson);
      return AppState.fromJson(jsonData);
    } else {
      return AppState();
    }
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(appStateKey, jsonEncode(toJson()));
  }

  factory AppState.fromJson(Map<String, dynamic> data) {
    return AppState(
      session: data["session"] != null
          ? models.Session.fromJson(data["session"] as Map<String, dynamic>)
          : null,
      user: data["user"] != null
          ? models.User.fromJson(data["user"] as Map<String, dynamic>)
          : null,
      schoolUser: data["school_user"] != null
          ? models.SchoolUser.fromJson(
              data["school_user"] as Map<String, dynamic>,
            )
          : null,
      school: data["school"] != null
          ? models.School.fromJson(data["school"] as Map<String, dynamic>)
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "session": session?.toJson(),
      "user": user?.toJson(),
      "school_user": schoolUser?.toJson(),
      "school": school?.toJson(),
    };
  }
}
