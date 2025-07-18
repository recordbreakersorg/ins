import 'package:flutter/material.dart';
import 'package:ins/appstate.dart';
import 'package:ins/widgets/imsg.dart';
import 'package:ins/widgets/loading.dart';
import 'blank/dashboard.dart';
import 'package:ins/l10n/app_localizations.dart';

Widget loadingDashboard(BuildContext context, {bool backButton = true}) {
  return Scaffold(
    appBar: AppBar(
      title: Text(AppLocalizations.of(context)!.loadingYourDashboard),
      leading: backButton ? BackButton() : null,
    ),
    body: Column(
      children: [
        LoadingWidget(
          messages: AppLocalizations.of(context)!.waitingMessages.split("|"),
        ),
      ],
    ),
  );
}

Widget errorLoadingDashboard(
  BuildContext context,
  String message, {
  bool backButton = true,
}) {
  return Scaffold(
    appBar: AppBar(
      title: Text(AppLocalizations.of(context)!.loadingYourDashboard),
      leading: backButton ? BackButton() : null,
    ),
    body: Column(
      children: [IMsgWidget(icon: Icon(Icons.error), message: Text(message))],
    ),
  );
}

Future<Widget> getDashboard(AppState? state) async {
  state ??= await AppState.load();
  if (state.schoolUser == null) {
    return BlankDashboard(appState: state);
  } else {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Builder(
          builder: (context) => Text(AppLocalizations.of(context)!.nothingHere),
        ),
      ),
    );
  }
}

Widget loadDashboard(AppState? state) {
  return FutureBuilder(
    future: getDashboard(state),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return snapshot.data!;
      } else if (snapshot.connectionState == ConnectionState.waiting) {
        return loadingDashboard(context);
      } else {
        return errorLoadingDashboard(context, snapshot.error.toString());
      }
    },
  );
}
