import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './base.dart';
import './errorpage.dart';
import '../../backend/models.dart' as models;

class DashboardSchoolsPage extends DashboardBase {
  const DashboardSchoolsPage({
    super.key,
    super.navIndex = 2,
    super.title = "Your schools",
    required super.session,
    required super.user,
  });
  @override
  Widget buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Center(
        child: Column(
          children: [
            FutureBuilder(
              future: user.getSchools(session),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ErrorPage(
                    title: "Error",
                    description: "Unable to load schools ${snapshot.error}",
                  );
                } else if (!snapshot.hasData) {
                  return CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  );
                } else if (snapshot.data!.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 30,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "No schools",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Container(height: 10),
                          Text(
                            "You are a member of no school yet",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          FutureBuilder(
                            future: user.getSchools(session),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              }
                              final schools = snapshot.data!;
                              return Column(
                                children:
                                    schools.map((school) {
                                      return Text(school.name);
                                    }).toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple.shade300, Colors.amber.shade300],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      "explore",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentSchoolCard extends StatelessWidget {
  final models.Session session;
  final models.User student;
  final models.School school;
  const StudentSchoolCard({
    super.key,
    required this.session,
    required this.student,
    required this.school,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
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
                      school.profile.getPath(),
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
                        Container(height: 20),
                        Text(
                          school.name,
                          style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ).copyWith(
                            color: const Color.fromRGBO(55, 71, 79, 1),
                          ),
                        ),
                        Container(height: 5),
                        Text(
                          "a school",
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ).copyWith(
                            color: const Color.fromRGBO(158, 158, 158, 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
