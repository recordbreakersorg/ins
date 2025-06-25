import 'package:flutter/material.dart';
import 'package:ins/l10n/app_localizations.dart';
import 'package:ins/locale.dart' as locale_manager; // Aliased
import 'package:provider/provider.dart';

class LocaleChooserWidget extends StatelessWidget {
  const LocaleChooserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the LocaleProvider instance
    final localeProvider = Provider.of<locale_manager.LocaleProvider>(context);

    // Determine the currently selected locale for the DropdownButton
    // It should be the locale from our provider if set,
    // otherwise, it's what Flutter has resolved (e.g., device locale).
    Locale? currentLocaleInDropdown;

    if (localeProvider.locale != null) {
      // Ensure the provider's locale is one of the supported ones for the dropdown
      currentLocaleInDropdown = AppLocalizations.supportedLocales.firstWhere(
        (l) => l.languageCode == localeProvider.locale!.languageCode,
        orElse: () => Localizations.localeOf(context), // Fallback
      );
    } else {
      // If provider has no locale (e.g. fresh install, or locale cleared),
      // use the locale Flutter is currently using.
      currentLocaleInDropdown = Localizations.localeOf(context);
      // Ensure this resolved locale is one of our explicit supported ones for the dropdown
      // This can happen if Localizations.localeOf(context) picks a device locale
      // that has a country code but our supportedLocales only has language code.
      currentLocaleInDropdown = AppLocalizations.supportedLocales.firstWhere(
        (l) => l.languageCode == currentLocaleInDropdown!.languageCode,
        orElse: () =>
            AppLocalizations.supportedLocales.first, // Ultimate fallback
      );
    }

    return DropdownButtonHideUnderline(
      // Often looks better in AppBar
      child: DropdownButton<Locale>(
        value: currentLocaleInDropdown,
        icon: const Icon(Icons.language),
        style: TextStyle(
          color: Theme.of(context).appBarTheme.iconTheme?.color ?? Colors.white,
        ), // Match AppBar icon color
        dropdownColor:
            Theme.of(context).appBarTheme.backgroundColor ??
            Theme.of(context).primaryColor, // Match AppBar background
        items: AppLocalizations.supportedLocales.map<DropdownMenuItem<Locale>>((
          Locale loc,
        ) {
          return DropdownMenuItem<Locale>(
            value: loc,
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Text(
                locale_manager.getLocaleFullName(loc) ?? loc.languageCode,
                style: TextStyle(
                  // Ensure text color is visible on dropdown background
                  color:
                      Theme.of(context).textTheme.bodyLarge?.color ??
                      (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: (Locale? newValue) {
          if (newValue != null) {
            locale_manager.setCurrentLocale(context, newValue.languageCode);
          }
        },
      ),
    );
  }
}
