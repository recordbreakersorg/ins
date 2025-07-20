import 'package:flutter/material.dart';
import 'package:ins/appstate.dart';
import 'package:ins/pages/splash.dart';
import 'package:ins/widgets/imsg.dart';
import 'welcomepage.dart';
import 'package:ins/l10n/app_localizations.dart';
import 'dashboard/dashboard.dart';

Widget _inBlank(Widget child) {
  return Scaffold(body: child);
}

Widget getPage(AppState appState) {
  if (appState.session == null) {
    return const WelcomePage();
  } else {
    return FutureBuilder(
      future: getDashboard(appState),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        } else if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          return _inBlank(
            IMsgWidget(
              icon: const Icon(Icons.error),
              message: Text(AppLocalizations.of(context)!.errorLoadingYourDashboard),
            ),
          );
        }
      },
    );
  }
}
