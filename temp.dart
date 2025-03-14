// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  // Replace with the actual values you want to query with.
  final String name = 'YOUR_NAME';
  final String token = 'YOUR_TOKEN';

  // Construct the URL using http (not https)
  final Uri url = Uri.http(
    'localhost:8080',
    '/api/v1/session/signup',
    {'name': name, 'token': token},
  );

  try {
    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      // Decode and print the JSON response
      final dynamic jsonResponse = jsonDecode(response.body);
      print('Response: $jsonResponse');
    } else {
    }
  } catch (e) {
    print('An error occurred: $e');
  }
}
