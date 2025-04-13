import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'model.dart';

class SessionManager {
  static const String _sessionKey = 'session';
  Session? _session;
  Session? get sessions => _session;
  static Session? session;

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsStr = prefs.getString(_sessionKey);
    if (sessionsStr != null) {
      final dynamic jsonData = json.decode(sessionsStr);
      _session = Session.fromJson(jsonData);
    }
  }

  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsStr = json.encode(_session?.toJson());
    await prefs.setString(_sessionKey, sessionsStr);
  }

  Future<Session?> signin(String name, String password) async {
    final Uri url = Uri.http('localhost:8080', '/api/v1/session/signin', {
      'name': name,
      'password': password,
    });

    try {
      final http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] < 0) {
          throw Exception("Failed to signin session: ${jsonData['message']}");
        }
        final newSession = Session.fromJson(jsonData['session']);
        _session = newSession;
        await _saveSession();
        return newSession;
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }

  Future<Session?> signup(String name, String password) async {
    final Uri url = Uri.http('localhost:8080', '/api/v1/session/signup', {
      'name': name,
      'password': password,
    });

    try {
      final http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['status'] < 0) {
          throw Exception("Failed to signup session: ${jsonData['message']}");
        }
        final newSession = Session.fromJson(jsonData['session']);
        _session = newSession;
        await _saveSession();
        return newSession;
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred: $e');
    } // Construct the URL using http (not https)
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
}

final sessionManager = SessionManager();
