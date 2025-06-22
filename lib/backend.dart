import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:ins/models.dart' as models;
import 'package:http/http.dart' as http;

String getBackendBase() {
  return kDebugMode ? "http://192.168.1.192:8080" : "https://localhost";
}

Future<Map<String, dynamic>> query(
  String url,
  Map<String, dynamic> data,
  models.Session? session,
) async {
  final response = await http.post(
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
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load data from backend(Invalid status code)');
  }
}
