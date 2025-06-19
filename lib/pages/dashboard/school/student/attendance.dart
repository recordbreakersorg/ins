import 'dart:math';

import 'package:flutter/material.dart';
import '../attendance.dart';
import 'base.dart';

class StudentAttendanceSchoolPage extends StudentSchoolViewBase {
  const StudentAttendanceSchoolPage({
    super.key,
    required super.session,
    required super.user,
    required super.member,
    required super.school,
    super.index = 3,
  });

  @override
  Widget buildContent(BuildContext context) {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month, 1);
    final previousMonth = DateTime(now.year, now.month - 1, 1);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          AttendanceWidget(
            displayedMonth: previousMonth,
            attendanceRecords: _generateSampleData(
              previousMonth,
              currentDate: now,
            ),
            currentDate: now,
          ),
          const SizedBox(height: 24),
          AttendanceWidget(
            displayedMonth: currentMonth,
            attendanceRecords: _generateSampleData(
              currentMonth,
              currentDate: now,
            ),
            currentDate: now,
          ),
        ],
      ),
    );
  }

  Map<DateTime, List<AttendancePeriod>> _generateSampleData(
    DateTime month, {
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
        final random = Random(date.day * date.month);

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
