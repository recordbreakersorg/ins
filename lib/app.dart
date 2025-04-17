import 'package:flutter/material.dart';
import 'package:ins/pages/dashboard/errorpage.dart';
import 'pages/welcome.dart';
import 'theme.dart';
import './backend/sessions.dart';
import './pages/dashboard/dashboard.dart';

class InS extends StatelessWidget {
  const InS({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intranet of Schools',
      darkTheme: themeManager.darkTheme,
      theme: themeManager.lightTheme,
      themeMode: themeManager.themeMode,
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
            print(" has session${sessionManager.session}");
            return FutureBuilder(
              future: sessionManager.session!.getUser(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: const ErrorPage(
                      title: "Error loading your session",
                      description:
                          "Unable to load your session, please try again later.",
                      //icon: Icon(Icons.error_outline_rounded),
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
                  print(
                    "User: ${snapshot.data}, session ${sessionManager.session}",
                  );
                  return DashboardPage(
                    session: sessionManager.session!,
                    user: snapshot.data!,
                  );
                }
              },
            );
          } else {
            return WelcomePage(title: 'Welcome to the Intranet of Schools');
          }
        },
      ),
    );
  }
}
