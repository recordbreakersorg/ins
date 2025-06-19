import 'package:flutter/material.dart';
import './base.dart';

class StudentSchoolDashboardPage extends StudentSchoolViewBase {
  const StudentSchoolDashboardPage({
    super.key,
    required super.school,
    required super.member,
    required super.session,
    required super.user,
    super.index = 0,
  });
  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Hero(
                          tag: school.profile.getPath(),
                          child: Image.network(
                            school.profile.getPath(),
                            width: 150,
                            height: 150,
                          ),
                        ),
                        SizedBox(width: 20),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              school.info.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "@${school.school_name}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                backgroundColor: Theme.of(
                                  context,
                                ).primaryColor.withOpacity(0.3),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Hy ${user.info.name}, what would you like to do?",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
