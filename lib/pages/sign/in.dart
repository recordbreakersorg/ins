import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ins/backend/models.dart';
import '../../backend/sessions.dart';
import '../../theme.dart';

class SigninChooserPage extends StatelessWidget {
  const SigninChooserPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backgrounds/welcome3.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  sessionManager.sessions.isNotEmpty
                      ? sessionManager.sessions.map((session) {
                        return StudentSchoolCard(session: session);
                      }).toList()
                      : <Widget>[
                        Text(
                          'No sessions found',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(100, 10, 10, 10),
                          ),
                        ),
                      ],
            ),
          ),
        ),
      ),
    );
  }
}

class StudentSchoolCard extends StatelessWidget {
  final Session session;
  const StudentSchoolCard({super.key, required this.session});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: session.getUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        final user = snapshot.data!;
        print(user.profile.getPath());
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(45),
                      child: Image.network(
                        user.profile.getPath(),
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            user.name,
                            style: GoogleFonts.lato(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ).copyWith(
                              color: const Color.fromRGBO(55, 71, 79, 1),
                            ),
                          ),
                          Container(height: 5),
                          Text(
                            user.role,
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ).copyWith(
                              color: const Color.fromRGBO(158, 158, 158, 1),
                            ),
                          ),
                          // Add some spacing between the subtitle and the text
                          Container(height: 5),
                          // Add a text widget to display some text
                          FutureBuilder(
                            future: user.getSchool(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              } else {
                                final school = snapshot.data!;
                                return Text(
                                  school.name,
                                  maxLines: 2,
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ).copyWith(
                                    color: const Color.fromRGBO(97, 97, 97, 1),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }, //67d32bd5e4a0fa024c191734, ama2025-03-13-20:02:45.179607782-+0100-WAT-m=+546.656327203
    );
  }
}
