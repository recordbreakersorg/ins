import 'package:flutter/material.dart';
import 'package:ins/appstate.dart';
import 'package:ins/widgets/imsg.dart';
import 'package:ins/widgets/loading.dart';
import 'welcomepage.dart';
import 'package:ins/l10n/app_localizations.dart';
import 'dashboard/dashboard.dart';

Widget _inBlank(Widget child) {
  return Scaffold(body: child);
}

Widget getPage() {
  return FutureBuilder<AppState>(
    future: AppState.load(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return _inBlank(
          LoadingWidget(
            messages: AppLocalizations.of(
              context,
            )!.homeLoadingMessages.split("|"),
            switchInterval: Duration(seconds: 1),
          ),
        );
      } else if (snapshot.hasData) {
        final appState = snapshot.data!;
        if (appState.session == null) {
          return const WelcomePage();
        } else {
          return FutureBuilder(
            future: getDashboard(snapshot.data!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!;
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return _inBlank(
                  LoadingWidget(
                    messages: AppLocalizations.of(
                      context,
                    )!.waitingMessages.split("|"),
                    switchInterval: Duration(seconds: 1),
                  ),
                );
              } else {
                return _inBlank(
                  IMsgWidget(
                    icon: Icon(Icons.error),
                    message: Text(AppLocalizations.of(context)!.errorLoadingYourDashboard),
                  ),
                );
              }
            },
          );
        }
      } else {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
    },
  );
}
