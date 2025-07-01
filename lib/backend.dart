import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:ins/models.dart' as models;
import 'package:http/http.dart' as http;

String getBackendBase() {
  return kDebugMode
      ? "http://localhost:8080"
      : "https://ins-backend-prod.rbs.cm";
}

Future<Map<String, dynamic>> query(
  String url,
  Map<String, String?> data,
  models.Session? session,
) async {
  late http.Response response;
  try {
    response = await http.post(
      Uri.parse("${getBackendBase()}/api/$url"),
      body: data,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        if (session != null) ...{
          'session-token': session.token,
          'session-id': session.id.toString(),
        },
      },
    );
  } catch (e) {
    throw Exception(
      'Could not connect to backend, check your internet connection. $e',
    );
  }
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load data from backend(Invalid status code)');
  }
}

class Status {
  static const notFound = -5;
  static const error = -1;
  static const ok = 0;
}
