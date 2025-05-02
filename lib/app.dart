import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:ins/errorpage.dart';
import 'pages/welcome.dart';
import 'theme.dart';
import './backend/sessions.dart';
import './pages/dashboard/dashboard.dart';
import './analytics.dart' as analytics;
import 'package:flutter_localizations/flutter_localizations.dart';

class InS extends StatelessWidget {
  const InS({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (_, _) {
        return MaterialApp(
          navigatorObservers: [
            ...(analytics.analytics != null
                ? [FirebaseAnalyticsObserver(analytics: analytics.analytics!)]
                : []),
          ],
          title: "Intranet of Schools",
          darkTheme: themeManager.darkTheme,
          theme: themeManager.lightTheme,
          themeMode: themeManager.themeMode,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [Locale('en'), Locale('fr')],
          home: FutureBuilder(
            future: sessionManager.loadSession(),
            builder: (context, snapshot) {
              // Handle error state
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(child: Text('Error: ${snapshot.error}')),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (sessionManager.hasSession()) {
                return FutureBuilder(
                  future: sessionManager.session!.getUser(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Scaffold(
                        body: Container(
                          color: Theme.of(context).colorScheme.errorContainer,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ErrorPage(
                                title: "Error loading your session",
                                description: snapshot.error!.toString(),
                                icon: Icon(
                                  Icons.signal_wifi_off,
                                  color: Theme.of(context).colorScheme.error,
                                  size: 200,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: Center(
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        () => Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const InS(),
                                          ),
                                        ),
                                    icon: Icon(Icons.refresh),
                                    label: Text("Reload"),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: Center(
                                  child: TextButton(
                                    onPressed:
                                        () => Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              sessionManager.clearSession();
                                              return const InS();
                                            },
                                          ),
                                        ),
                                    child: Text("logout"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        appBar: AppBar(title: Text("Error")),
                      );
                    } else if (!snapshot.hasData) {
                      return Scaffold(
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Theme.of(context).primaryColor,
                              ),
                              SizedBox(height: 30),
                              Text("Loading your online accounts..."),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return DashboardPage(
                        session: sessionManager.session!,
                        user: snapshot.data!,
                      );
                    }
                  },
                );
              } else {
                return WelcomePage(title: "Welcome to the Intranet of Schools");
              }
            },
          ),
        );
      },
    );
  }
}
