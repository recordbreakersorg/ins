import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';
import './assistant/home.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
              GoogleProvider(
                clientId:
                    "825679026565-2giegkc01qru93n8gnoqitml88q9a9ef.apps.googleusercontent.com",
              ),
            ],
            actions: [
              AuthStateChangeAction<SignedIn>((context, state) {
                if (state.user != null) {
                  print("Got:::-----:::${state.user}");
                  print(state.toString());
                }
              }),
            ],
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child:
                    action == AuthAction.signIn
                        ? const Text('Welcome to FlutterFire, please sign in!')
                        : const Text('Welcome to Flutterfire, please sign up!'),
              );
            },
            footerBuilder: (context, action) {
              return const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  'By signing in, you agree to our terms and conditions.',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            },
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset('assets/is_logo.png'),
                ),
              );
            },
            sideBuilder: (context, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset('is_logo.png'),
                ),
              );
            },
          );
        }

        return FutureBuilder(
          future: assistant(context),
          builder: (context, assistantSnapshot) {
            if (assistantSnapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            return assistantSnapshot.data ?? const SizedBox();
          },
        );
      },
    );
  }
}
