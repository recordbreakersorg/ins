import 'package:flutter/foundation.dart';
import './models/session.dart';
import 'package:http/http.dart' as http;

// ignore: non_constant_identifier_names
String get_backend_url() {
  return kDebugMode
      ? "http://${get_backend_base()}"
      : "https://${get_backend_base()}";
}

// ignore: non_constant_identifier_names
String get_backend_base() {
  if (kDebugMode) {
    print("Debug mode");
    return "192.168.1.191:8080";
  } else {
    return "ins-backend.up.railway.app";
  }
}

Future<http.Response> apiRequest(
  String url,
  Map<String, dynamic> data,
  Session? session,
) {
  return http.post(
    Uri.parse("${get_backend_url()}/api/v1/$url"),
    body: data,
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      if (session != null) ...{
        'session-token': session.token,
        'session-id': session.id,
      },
    },
  );
}
