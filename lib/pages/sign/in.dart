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
            children: sessionManager.sessions.map((session) {
              return FutureBuilder(
                future: session.getUser(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  final user = snapshot.data!;
                  return Card(
                    child: Row(children: [
                      Text(user.name),
                    ],),
                  );
                }//67d32bd5e4a0fa024c191734, ama2025-03-13-20:02:45.179607782-+0100-WAT-m=+546.656327203
              );
            }).toList(),
          ),
        )
      ),
    );
  }
}

