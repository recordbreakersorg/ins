import 'dart:convert';
import '../data/cachey.dart';
import 'package:flutter/foundation.dart';
import './models/session.dart';
import 'package:http/http.dart' as http;
import 'package:ins/offline.dart';

// ignore: non_constant_identifier_names
String get_backend_url() {
  return kDebugMode
      ? "http://${get_backend_base()}"
      : "https://${get_backend_base()}";
}

// ignore: non_constant_identifier_names
String get_backend_base() {
  if (kDebugMode) {
    return "192.168.1.192:8080";
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
    throw Exception(
      'Failed to load data at $url status: ${response.statusCode}',
    );
  }
}

Future<Map<String, dynamic>> cacheableQuery(
  String key,
  String url,
  Map<String, dynamic> data,
  Session? session,
) async {
  try {
    if (connectivity.offline) throw Exception("You are not connected");
    final value = await apiQuery(url, data, session);
    await cache.set(key, jsonEncode(value));
    return value;
  } catch (e) {
    return cache.get(key).then((value) {
      if (value != null) {
        return jsonDecode(value);
      } else {
        throw Exception(e);
      }
    });
  }
}

Future<String?> getTerms() async {
  try {
    final response = await cacheableQuery("terms", "terms", {}, null);
    if (response["status"] >= 0) {
      return response["terms"];
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}
