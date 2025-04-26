import 'package:firebase_core/firebase_core.dart';
import 'package:ins/firebase_options.dart';

import 'app.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //print("session loaded");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //print("Running");
  /*var response = await post(
    Uri.parse('http://192.168.1.191/api/v1/user/create'),
    body: {'name': 'engon'},
  );
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
*/
  runApp(const InS());
}
