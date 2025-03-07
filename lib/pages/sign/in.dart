import 'package:flutter/material.dart';

class SigninChooserPage extends StatelessWidget {
  const SigninChooserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backgrounds/welcome3.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            ],
          ),
        )
      ),
    );
  }
}

