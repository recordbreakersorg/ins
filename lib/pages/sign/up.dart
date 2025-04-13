import 'package:flutter/material.dart';
import './assistant/home.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backgrounds/welcome3.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Card(
              margin: EdgeInsets.all(20.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FilledButton(
                      onPressed: () async {
                        await launchAssistant(context);
                      },
                      child: Text('Manual Signup >'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
