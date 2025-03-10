import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  final String token;
  final String userId;
  // Add additional fields if needed

  Session({required this.token, required this.userId});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      token: json['token'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user_id': userId,
    };
  }
}

class SessionManager {
  static const String _sessionsKey = 'user_sessions';
  List<Session> _sessions = [];
  List<Session> get sessions => _sessions;

  Future<void> loadSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsStr = prefs.getString(_sessionsKey);
    if (sessionsStr != null) {
      final List<dynamic> jsonData = json.decode(sessionsStr);
      _sessions = jsonData.map((json) => Session.fromJson(json)).toList();
    }
  }

  Future<void> _saveSessions() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionsStr = json.encode(_sessions.map((session) => session.toJson()).toList());
    await prefs.setString(_sessionsKey, sessionsStr);
  }

  Future<Session?> signup(String name, String token) async {
  final Uri url = Uri.http(
    'localhost:8080',
    '/api/v1/session/signup',
    {'name': name, 'token': token},
  );

  try {
    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic jsonResponse = jsonDecode(response.body);
      final jsonData = json.decode(response.body);
      if (jsonData['status'] != 200) {
        throw Exception("Failed to signup session: ${jsonData['message']}");
      }
      final newSession = Session.fromJson(jsonData['session']);
      _sessions.add(newSession);
      await _saveSessions();
      return newSession;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('An error occurred: $e');
  }  // Construct the URL using http (not https)
  }

  Future<void> clearSessions() async {
    _sessions = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionsKey);
  }
  Future<void> deleteSession(Session session) async {
    _sessions.remove(session);
    await _saveSessions();
  }
  
}

final sessionManager = SessionManager();