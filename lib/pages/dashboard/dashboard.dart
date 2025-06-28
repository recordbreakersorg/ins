import 'package:flutter/material.dart';
import 'package:ins/appstate.dart';
import 'blank/dashboard.dart';

Future<Widget> getDashboard(AppState? state) async {
  state ??= await AppState.load();
  if (state.schoolUser == null) {}
}
