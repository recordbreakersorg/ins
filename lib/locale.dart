import 'package:shared_preferences/shared_preferences.dart';

const localeKey = "is-locale";
String? locale;

Future<void> init() async {
  final prefs = await SharedPreferences.getInstance();
  locale = prefs.getString(localeKey);
}

Future<void> set(String? val) async {
  locale = val;
  final prefs = await SharedPreferences.getInstance();
  if (val != null) {
    prefs.setString(localeKey, val);
  } else {
    prefs.remove(localeKey);
  }
}

String? get() {
  return locale;
}

bool isSet() {
  return locale != null;
}
