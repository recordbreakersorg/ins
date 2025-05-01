import 'package:flutter/material.dart';
import 'package:ins/pages/dashboard/school/admin/users.dart';
import './base.dart';

class AdminSchoolDashboardPage extends AdminSchoolViewBase {
  const AdminSchoolDashboardPage({
    super.key,
    super.index = 0,
    required super.school,
    required super.member,
    required super.session,
    required super.user,
  });
  @override
  String getTitle(BuildContext context) {
    return "Dashboard";
  }

  @override
  Widget buildContent(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Text(
              "Welcome ${user.info.name}, what would you like to do?",
              style: TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => AdminSchoolUsersPage(
                                  school: school,
                                  member: member,
                                  session: session,
                                  user: user,
                                ),
                          ),
                        );
                        // Handle button press
                      },
                      child: Text("Manage Users"),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle button press
                      },
                      child: Text("Manage Classes"),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle button press
                      },
                      child: Text("View Reports"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
