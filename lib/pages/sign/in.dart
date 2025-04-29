import 'package:flutter/material.dart';
import '../../backend/sessions.dart';
import '../dashboard/dashboard.dart';
import '../../analytics.dart' as analytics;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    analytics.screen("signin page");
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
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.yourName,
                        prefixIcon: Icon(Icons.person),
                        fillColor: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.yourPassword,
                        prefixIcon: Icon(Icons.lock),
                        fillColor: Theme.of(context).colorScheme.inversePrimary,
                      ),
                      maxLength: 14,
                    ),
                    SizedBox(height: 20),
                    FilledButton(
                      onPressed: () async {
                        try {
                          final session = await sessionManager.signin(
                            _nameController.text,
                            _codeController.text,
                          );
                          if (session != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.successfullySignedUp,
                                ),
                              ),
                            );

                            final user = await session.getUser();
                            analytics.signin(user.username, "manual");
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder:
                                    (context) => DashboardPage(
                                      session: session,
                                      user: user,
                                    ),
                              ),
                              (route) => false,
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.signin),
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
