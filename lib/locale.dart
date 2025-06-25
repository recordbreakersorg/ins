// locale.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ins/l10n/app_localizations.dart'; // Assuming this defines supportedLocales

const Map<String, String> localeNames = {
  "en": "English",
  "fr": "Français",
  // Add other language names here
};

String? getLocaleFullName(Locale? locale) {
  if (locale == null) return null;
  return localeNames[locale.languageCode];
}

class LocaleProvider with ChangeNotifier {
  Locale? _locale;
  static const String _selectedLocaleKey = 'selected_locale_language_code';
  bool _isLoading = true; // To track initial loading

  Locale? get locale => _locale;
  bool get isLoading => _isLoading; // Expose loading state if needed elsewhere

  LocaleProvider() {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    _isLoading = true;
    notifyListeners(); // Notify UI that loading has started

    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_selectedLocaleKey);

    if (languageCode != null) {
      final foundLocale = AppLocalizations.supportedLocales.firstWhere(
        (sl) => sl.languageCode == languageCode,
        orElse: () {
          // If saved locale is no longer supported, clear it and use null (device default)
          // or fallback to the first supported. Let's try null first.
          // _removeSavedLocale(); // Optionally remove invalid preference
          // return AppLocalizations.supportedLocales.first;
          print(
            "Saved locale '$languageCode' not in supported list, using device default or first supported.",
          );
          return AppLocalizations
              .supportedLocales
              .first; // Or null to let MaterialApp decide
        },
      );
      _locale = foundLocale;
    } else {
      // No saved locale, _locale remains null, MaterialApp will use device locale or first supported.
      _locale = null;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setLocale(Locale newLocale) async {
    if (!AppLocalizations.supportedLocales.any(
      (sl) => sl.languageCode == newLocale.languageCode,
    )) {
      debugPrint("Locale ${newLocale.languageCode} is not supported.");
      return;
    }

    if (_locale?.languageCode != newLocale.languageCode) {
      _locale = newLocale;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_selectedLocaleKey, newLocale.languageCode);
      notifyListeners();
    }
  }

  Future<void> clearLocale() async {
    if (_locale != null) {
      _locale = null; // Let MaterialApp use device locale / resolution
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_selectedLocaleKey);
      notifyListeners();
    }
  }
}

// --- Global Singleton Access (Your current pattern) ---
// This part can remain if you prefer it, but Provider.of is often cleaner.
LocaleProvider? _globalLocaleProvider;

void init() {
  _globalLocaleProvider ??= LocaleProvider();
}

LocaleProvider getProvider() {
  if (_globalLocaleProvider == null) {
    // This case should ideally not happen if init() is called in main.dart
    debugPrint(
      "Warning: LocaleProvider accessed before init(). Initializing now.",
    );
    init();
  }
  return _globalLocaleProvider!;
}

// Helper functions (could also be methods on provider accessed via Provider.of)
// These are less necessary if you use Provider.of directly in widgets.
void setCurrentLocale(BuildContext context, String languageCode) {
  // Provider.of<LocaleProvider>(context, listen: false).setLocale(Locale(languageCode));
  getProvider().setLocale(Locale(languageCode)); // Using your singleton
}

void clearCurrentLocale(BuildContext context) {
  // Provider.of<LocaleProvider>(context, listen: false).clearLocale();
  getProvider().clearLocale(); // Using your singleton
}

Locale? getCurrentLocale() {
  // return Provider.of<LocaleProvider>(context, listen: false).locale;
  return getProvider().locale; // Using your singleton
}
