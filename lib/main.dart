import 'app.dart';
import 'backend/sessions.dart';
import 'package:flutter/material.dart';
void main() {
  sessionManager.loadSessions().then((_) {
    runApp(const InS());
  });
}

