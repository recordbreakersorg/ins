import 'package:flutter/material.dart';
import 'package:ins/appstate.dart';
import 'blank/dashboard.dart';
import 'package:ins/l10n/app_localizations.dart';

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
