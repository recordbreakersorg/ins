import 'dart:convert';

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
    return "10.42.0.1:8080";
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

Future<Map<String, dynamic>> apiQuery(
  String url,
  Map<String, dynamic> data,
  Session? session,
) async {
  final response = await apiRequest(url, data, session);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}
