import 'package:flutter/material.dart';
import '../../backend/sessions.dart';

class SigninChooserPage extends StatelessWidget {
  const SigninChooserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backgrounds/welcome3.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: sessionManager.sessions.map((session) => ElevatedButton(
                onPressed: () {
                },
                child: Text(session.userId),
              )).toList()
          ),
        )
      ),
    );
  }
}

