import 'package:flutter/material.dart';
import 'package:ins/widgets/imsg.dart';
import 'form.dart';
import 'package:ins/widgets/loading.dart';

class SubmitingPage extends StatelessWidget {
  final SignupForm form;
  const SubmitingPage({super.key, required this.form});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Creating your account")),
      body: FutureBuilder(
        future: form.submit(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: SizedBox(
                width: 500,
                child: IMsgWidget(
                  icon: Icon(
                    Icons.error,
                    size: 200,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  message: Text(
                    snapshot.error!.toString(),
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  actions: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Retry"),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final result = snapshot.data!;
            result.saveInState();
            return Center(
              child: SizedBox(
                width: 400,
                child: IMsgWidget(
                  icon: Icon(
                    Icons.check_circle,
                    size: 200,
                    color: Colors.greenAccent,
                  ),
                  message: Text("Account created succesfully"),
                  actions: OutlinedButton(
                    onPressed: () => _openDashboard(context),
                    child: const Text("Open dashboard"),
                  ),
                ),
              ),
            );
          } else {
            return LoadingWidget(
              messages: [
                "Creating your account..",
                "Adding your preferences..",
                "Updating our database...",
                "Putting in your contact information..",
                "Looking for potential reelatives...",
                "Generating your dashboard",
              ],
            );
          }
        },
      ),
    );
  }

  void _openDashboard(BuildContext context) {}
}
