import 'package:flutter/material.dart';
import 'sign/up.dart';
import 'sign/in.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(
      //  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //  title: Text(title),
      //),
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
                child: Image.asset('assets/is_logo.png', width: 200, height: 200),
              ),
              const Text(
                'Welcome!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SigninChooserPage()));
                    },
                    child: const Text('Login'),
                  ),
                  const SizedBox(width: 20),
                  FilledButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignupChooserPage()));
                    },
                    child: const Text('Signup'),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}
