import 'dart:convert';
import './backend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './models/session.dart';

class SessionManager {
  static const String _sessionKey = 'session';
  Session? _session;
  Session? get session => _session;

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsStr = prefs.getString(_sessionKey);
    if (sessionsStr != null) {
      final dynamic jsonData = json.decode(sessionsStr);
      _session = Session.fromJson(jsonData);
    }
    print("loaded session $_session");
  }

  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsStr = json.encode(_session?.toJson());
    await prefs.setString(_sessionKey, sessionsStr);
  }

  Future<Session?> signin(String name, String password) async {
    final response = await apiQuery("signin", {
      "username": name,
      "password": password,
    }, null);
    if (response['status'] < 0) {
      throw Exception("Error: ${response['message']}");
    }
    final session = Session.fromJson(response['session']);

    setSession(session);

    return session;
  }

  Future<void> clearSession() async {
    _session = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  Future<void> logout() async {
    _session = null;
    await _saveSession();
  }

  bool hasSession() {
    return _session != null;
  }

  Future<void> setSession(Session session) async {
    _session = session;
    await _saveSession();
  }
}

final sessionManager = SessionManager();
