import 'package:flutter/material.dart';
import 'package:ins/pages/sign/assistant/home.dart';
import './sign/in.dart';
import './sign/up.dart';
import 'package:google_fonts/google_fonts.dart';
import '../analytics.dart' as analytics;

class WelcomePage extends StatelessWidget {
  final String title;
  const WelcomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    analytics.screen("welcome page");
    return Scaffold(
      body: DecoratedBox(
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
              Padding(
                padding: const EdgeInsets.only(bottom: 100.0),
                child: Image.asset(
                  'assets/is_logo.png',
                  width: 200,
                  height: 200,
                ),
              ),
              Text("Welcome!", style: GoogleFonts.lato(fontSize: 30)),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SigninPage()),
                      );
                    },
                    child: Text("Connect"),
                  ),
                  const SizedBox(width: 20),
                  FilledButton(
                    onPressed: () {
                      //Navigator.push(
                      //  context,
                      //  MaterialPageRoute(builder: (context) => SignupPage()),
                      //);
                      launchAssistant(context);
                    },
                    child: Text("Register"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
