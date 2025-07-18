import 'package:flutter/material.dart';
import 'package:ins/l10n/app_localizations.dart';

String? chechEmail(BuildContext context, String email) {
  final match = RegExp("[^a-zA-Z0-9@.]").firstMatch("email");
  if (match != null) {
    return AppLocalizations.of(context)!.invalidCharacterInEmail +
        match[0].toString();
  }
  if (!email.contains("@")) {
    return AppLocalizations.of(context)!.emailShouldContain;
  }
  final parts = email.split("@");
  if (parts.length != 2) {
    return AppLocalizations.of(context)!.emailShouldContain1;
  }
  if (parts[0].length < 2) {
    return AppLocalizations.of(context)!.emailNameTooShort;
  }
  if (!parts[1].contains(".")) {
    return AppLocalizations.of(context)!.invalidEmailDomainsecondPart;
  }
  for (var element in parts[1].split(".")) {
    if (element.isEmpty) {
      return AppLocalizations.of(context)!.invalidDomainComponent;
    }
  }
  return null;
}
