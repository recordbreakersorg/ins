import 'package:flutter/material.dart';
import 'package:ins/appstate.dart';
import 'package:ins/widgets/loading.dart';
import 'welcomepage.dart';

Widget getPage() {
  return FutureBuilder<AppState>(
    future: AppState.load(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Scaffold(
          body: LoadingWidget(
            messages: [
              "Loading app state...",
              "Verifying user details...",
              "Getting permissions from your schools..",
              "Verifying the age on your birth certificate...",
              "Please wait...",
              "Almost there...",
            ],
            switchInterval: Duration(seconds: 1),
          ),
        );
      } else if (snapshot.hasData) {
        final appState = snapshot.data!;
        if (appState.session == null) {
          return const WelcomePage();
        } else {
          return const Center(child: Text('Home Page Placeholder'));
        }
      } else {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
    },
  );
}
