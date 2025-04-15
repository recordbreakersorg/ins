import 'dart:convert';
import './backend.dart';
import 'package:http/http.dart' as http;
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
  }

  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsStr = json.encode(_session?.toJson());
    await prefs.setString(_sessionKey, sessionsStr);
  }

  Future<Session?> signin(String name, String password) async {
    final String backendUrl = get_backend_url();
    final uri = Uri.parse(backendUrl);
    final Uri url = Uri(
      scheme: uri.scheme,
      host: uri.host,
      port: uri.port,
      path: '/api/v1/session/signin',
      queryParameters: {'name': name, 'password': password},
    );
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
    return session != null;
  }

  Future<void> setSession(Session session) async {
    _session = session;
    await _saveSession();
  }
}

final sessionManager = SessionManager();
