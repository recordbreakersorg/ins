import 'package:flutter/material.dart';
import 'package:ins/l10n/app_localizations.dart';
import 'package:ins/widgets/imsg.dart';
import 'form.dart';
import 'package:ins/widgets/loading.dart';

class SubmitingPage extends StatelessWidget {
  final SignupForm form;
  const SubmitingPage({super.key, required this.form});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.creatingYourAccount),
      ),
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
                    child: Text(AppLocalizations.of(context)!.retry),
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
                  message: Text(
                    AppLocalizations.of(context)!.accountCreatedSuccesfuly,
                  ),
                  actions: OutlinedButton(
                    onPressed: () => _openDashboard(context),
                    child: Text(AppLocalizations.of(context)!.openDashboard),
                  ),
                ),
              ),
            );
          } else {
            return LoadingWidget(
              messages: AppLocalizations.of(
                context,
              )!.waitingMessages.split("|"),
            );
          }
        },
      ),
    );
  }

  void _openDashboard(BuildContext context) {}
}
