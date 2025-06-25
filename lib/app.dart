import 'package:flutter/material.dart';
import 'package:ins/theme.dart';
import 'package:ins/pages/home.dart'
    as home; // Ensure home.getPage() returns a Widget
import 'package:ins/l10n/app_localizations.dart';
import 'package:ins/locale.dart' as locale_manager; // Aliased
import 'package:provider/provider.dart';
import 'package:ins/widgets/loading.dart';

class ISApp extends StatelessWidget {
  const ISApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<locale_manager.LocaleProvider>(
      create: (_) => locale_manager.getProvider(),
      child: Consumer<locale_manager.LocaleProvider>(
        builder: (context, localeProvider, child) {
          return AnimatedBuilder(
            animation: themeManager,
            builder: (context, _) {
              if (localeProvider.isLoading) {
                return MaterialApp(
                  home: Scaffold(
                    body: LoadingWidget(messages: ["Loading your locale..."]),
                  ),
                );
              }
              return MaterialApp(
                title: 'IS',
                locale: localeProvider.locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
                localeResolutionCallback: (deviceLocale, supportedLocales) {
                  if (localeProvider.locale != null) {
                    return localeProvider.locale;
                  }
                  if (deviceLocale != null) {
                    for (var supportedLocale in supportedLocales) {
                      if (supportedLocale.languageCode ==
                          deviceLocale.languageCode) {
                        // You might want to check countryCode as well if it's important:
                        // && (deviceLocale.countryCode == null || supportedLocale.countryCode == deviceLocale.countryCode)
                        return supportedLocale;
                      }
                    }
                  }
                  return supportedLocales.first;
                },
                theme: themeManager.getTheme(),
                home: home.getPage(),
              );
            },
          );
        },
      ),
    );
  }
}
