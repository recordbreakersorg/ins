import 'package:flutter/material.dart';
import 'package:ins/appstate.dart';
import 'package:ins/widgets/loading.dart';
import 'welcomepage.dart';

Widget getPage() {
  return FutureBuilder<AppState>(
    future: AppState.load(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const LoadingWidget(
          messages: [
            "Loading app state...",
            "Please wait...",
            "Almost there...",
          ],
          switchInterval: Duration(seconds: 3),
        );
      } else if (snapshot.hasData) {
        //final appState = snapshot.data!;
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Welcome to the App!'),
              ElevatedButton(
                onPressed: () {
                  // Navigate to home page or perform some action
                },
                child: const Text('Go to Home Page'),
              ),
            ],
          ),
        );
      } else {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
    },
  );
}
