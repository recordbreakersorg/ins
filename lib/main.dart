import 'app.dart';
import 'backend/sessions.dart';
import 'package:flutter/material.dart';
void main() {
  sessionManager.loadSessions().then((_) {
    print("sessions loaded");
    runApp(const InS());
  });
  print("starting app");
}

