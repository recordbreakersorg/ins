import 'package:shared_preferences/shared_preferences.dart';

class Cachey {
  Future<String?> get(String key) async {
    print("Cachey getting key $key from sharedpreferneces");
    final instance = await SharedPreferences.getInstance();
    print("Got instance");
    return instance.getString(key);
  }

  Future<void> set(String key, String value) async {
    final instance = await SharedPreferences.getInstance();
    await instance.setString(key, value);
  }
}

final cache = Cachey();
