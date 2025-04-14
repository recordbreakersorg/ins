import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../backend/models/user.dart';

class SignupAssistantState {
  String? name;
  String? username;
  String? password;
  String? role;
  DateTime? dob;
  SignupAssistantState();
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "username": username,
      "password": password,
      "role": role,
      "dob": dob?.toIso8601String(),
    };
  }

  static Future<SignupAssistantState> loadOrCreate() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('signup_assistant_state');
    if (jsonStr != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(jsonStr);
        final state =
            SignupAssistantState()
              ..name = data['name']
              ..username = data['username']
              ..password = data['password']
              ..dob = data['dob'] != null ? DateTime.parse(data['dob']) : null
              ..role = data['role'];

        return state;
      } catch (_) {}
    }
    return SignupAssistantState();
  }

  Future<void> setRole(String role) async {
    this.role = role;
    await save();
  }

  Future<void> setName(String name) async {
    this.name = name;
    await save();
  }

  Future<void> setUsername(String username) async {
    this.username = username;
    await save();
  }

  Future<void> setPassword(String password) async {
    this.password = password;
    await save();
  }

  Future<void> setDoB(DateTime dob) async {
    this.dob = dob;
    await save();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('signup_assistant_state', jsonEncode(toJson()));
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('signup_assistant_state');
  }

  Future<User> createAccount() async {
    await Future.delayed(const Duration(seconds: 2));
    return User.create(username!, name!, password!, role!, dob!);
  }
}
