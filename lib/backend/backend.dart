import 'package:flutter/foundation.dart';

// ignore: non_constant_identifier_names
String get_backend_url() {
  return kDebugMode
      ? "http://${get_backend_base()}"
      : "https://${get_backend_base()}";
}

// ignore: non_constant_identifier_names
String get_backend_base() {
  if (kDebugMode) {
    return "localhost:2468";
  } else {
    return "insbackend.railway.app";
  }
}
