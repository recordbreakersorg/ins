import 'dart:io';

String? _cachedBackendUrl;

// ignore: non_constant_identifier_names
String get_backend_url() {
  return "http://${get_backend_base()}";
}

// ignore: non_constant_identifier_names
String get_backend_base() {
  _cachedBackendUrl ??= Platform.environment['INS_BACKEND_BASE'];
  if (_cachedBackendUrl == null) {
    return "https://is_backend.railway.app";
  }
  return _cachedBackendUrl!;
}
