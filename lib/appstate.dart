import 'package:ins/models.dart' as models;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

const appStateKey = "app-state";

class AppState {
  models.Session? session;
  models.User? user;
  AppState({this.session, this.user});
  static Future<AppState> load() async {
    await Future.delayed(Duration(seconds: 5));
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
      session: models.Session.fromJson(data["session"] as Map<String, dynamic>),
      user: models.User.fromJson(data["user"] as Map<String, dynamic>),
    );
  }
  Map<String, dynamic> toJson() {
    return {"session": session?.toJson(), "user": user?.toJson()};
  }
}
