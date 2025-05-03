import 'dart:developer';
import 'dart:math';
import 'package:flutter/material.dart';
import '../attendance.dart';
import 'base.dart';
import 'package:ins/backend/models.dart' as models;

class ParentAttendanceSchoolPage extends ParentSchoolViewBase {
  const ParentAttendanceSchoolPage({
    super.key,
    required super.session,
    required super.user,
    required super.member,
    required super.school,
    super.index = 2,
  });

  @override
  Widget buildContent(BuildContext context) {
    return FutureBuilder<List<models.SchoolMemberNUser>>(
      // Use FutureBuilder to handle async operation
      future: member.getTutoringNUsers(session), // Fetch the children/users
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          ); // Show loading indicator
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          ); // Show error message
        } else {
          final mnus =
              snapshot.data ??
              []; // Get the list of children, default to empty list

          if (mnus.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'You have no children/students assigned to your account.', //Inform the user
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else {
            return DefaultTabController(
              length: mnus.length, // Number of tabs equals number of children
              child: Column(
                children: [
                  TabBar(
                    isScrollable: true,
                    tabs:
                        mnus
                            .map((mnu) => Tab(text: mnu.user.info.name))
                            .toList(), //Use child name
                  ),
                  Expanded(
                    child: TabBarView(
                      children:
                          mnus
                              .map(
                                (mnu) =>
                                    _buildChildAttendanceView(context, mnu),
                              )
                              .toList(),
                    ),
                  ),
                ],
              ),
            );
          }
        }
      },
    );
  }

  // Separate widget builder for each child's attendance
  Widget _buildChildAttendanceView(
    BuildContext context,
    models.SchoolMemberNUser mnu,
  ) {
    print(mnu.user.info.name);
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month, 1);
    final previousMonth = DateTime(now.year, now.month - 1, 1);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Attendance for ${mnu.user.info.name}', // Display Child's Name
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AttendanceWidget(
            displayedMonth: previousMonth,
            attendanceRecords: _generateSampleData(
              previousMonth,
              mnu: mnu,
              currentDate: now,
            ), // Pass child
            currentDate: now,
          ),
          const SizedBox(height: 24),
          AttendanceWidget(
            displayedMonth: currentMonth,
            attendanceRecords: _generateSampleData(
              currentMonth,
              mnu: mnu,
              currentDate: now,
            ), // Pass child
            currentDate: now,
          ),
        ],
      ),
    );
  }

  // Modified data generation to include child-specific logic if needed
  Map<DateTime, List<AttendancePeriod>> _generateSampleData(
    DateTime month, {
    models.SchoolMemberNUser? mnu, // Added child parameter
    required DateTime currentDate,
  }) {
    final records = <DateTime, List<AttendancePeriod>>{};
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final subjects = [
      'Biology',
      'Chemistry',
      'Further Maths',
      'Pure Maths',
      'Physics',
      'Computer Science',
    ];

    for (
      var date = firstDay;
      date.isBefore(lastDay.add(const Duration(days: 1)));
      date = date.add(const Duration(days: 1))
    ) {
      if (date.weekday >= DateTime.monday && date.weekday <= DateTime.friday) {
        final periods = <AttendancePeriod>[];
        final random = Random(
          (date.day * date.month + Random(100).nextInt(100)).round(),
        ); // Make it child-specific

        for (final subject in subjects) {
          if (random.nextDouble() > 0.3) {
            final status = _getRandomStatus(random, date == currentDate);
            periods.add(
              AttendancePeriod(
                time: DateTime(
                  date.year,
                  date.month,
                  date.day,
                  8 + random.nextInt(8),
                ),
                courseName: subject,
                status: status,
              ),
            );
          }
        }

        if (periods.isNotEmpty) records[date] = periods;
      }
    }
    return records;
  }

  AttendanceStatus _getRandomStatus(Random random, bool isToday) {
    if (isToday) return AttendanceStatus.present;
    final weights = [0.7, 0.1, 0.15, 0.05];
    final value = random.nextDouble();
    double cumulative = 0.0;

    for (var i = 0; i < weights.length; i++) {
      cumulative += weights[i];
      if (value < cumulative) return AttendanceStatus.values[i];
    }
    return AttendanceStatus.present;
  }
}
