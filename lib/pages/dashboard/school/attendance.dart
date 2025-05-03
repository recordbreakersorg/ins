import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendanceWidget extends StatelessWidget {
  final DateTime displayedMonth;
  final Map<DateTime, List<AttendancePeriod>> attendanceRecords;
  final DateTime? currentDate;

  const AttendanceWidget({
    super.key,
    required this.displayedMonth,
    required this.attendanceRecords,
    this.currentDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceVariant.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.outline.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, colors, textTheme),
          const SizedBox(height: 16),
          _buildCalendarGrid(context, colors, textTheme),
          const SizedBox(height: 16),
          _buildLegend(colors, textTheme),
          const SizedBox(height: 8),
          _buildMonthSummary(context),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('MMMM y').format(displayedMonth),
            style: textTheme.titleLarge?.copyWith(
              color: colors.onSurface,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          IconButton(
            icon: Icon(Icons.info_outline_rounded, color: colors.primary),
            onPressed: () => _showAttendanceInfo(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(
    BuildContext context,
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: _daysInMonth(),
      itemBuilder: (context, index) {
        final dayDate = DateTime(
          displayedMonth.year,
          displayedMonth.month,
          index + 1,
        );
        final isToday =
            currentDate != null &&
            dayDate.year == currentDate!.year &&
            dayDate.month == currentDate!.month &&
            dayDate.day == currentDate!.day;

        return _DayTile(
          dayDate: dayDate,
          periods: attendanceRecords[dayDate],
          isToday: isToday,
          colors: colors,
          textTheme: textTheme,
        );
      },
    );
  }

  int _daysInMonth() {
    return DateTime(displayedMonth.year, displayedMonth.month + 1, 0).day;
  }

  Widget _buildMonthSummary(BuildContext context) {
    final presentDays =
        attendanceRecords.values
            .where(
              (periods) =>
                  periods.any((p) => p.status == AttendanceStatus.present),
            )
            .length;
    final totalDays = attendanceRecords.keys.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Expanded(
            child: LinearProgressIndicator(
              value: totalDays > 0 ? presentDays / totalDays : 0,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              color: Theme.of(context).colorScheme.primary,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${((presentDays / totalDays) * 100).toStringAsFixed(1)}% Present',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(ColorScheme colors, TextTheme textTheme) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children:
          AttendanceStatus.values.map((status) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _getStatusColor(colors, status),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  status.name.toUpperCase(),
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.onSurface.withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }

  Color _getStatusColor(ColorScheme colors, AttendanceStatus status) {
    return switch (status) {
      AttendanceStatus.present => colors.primary.withOpacity(0.2),
      AttendanceStatus.absent => colors.error.withOpacity(0.2),
      AttendanceStatus.late => colors.tertiary.withOpacity(0.2),
      AttendanceStatus.partial => colors.secondary.withOpacity(0.2),
      AttendanceStatus.holiday => colors.surfaceVariant.withOpacity(0.4),
    };
  }

  void _showAttendanceInfo(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              'Attendance Legend',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLegendItem(
                  context,
                  AttendanceStatus.present,
                  'Present in all classes',
                ),
                _buildLegendItem(
                  context,
                  AttendanceStatus.absent,
                  'Absent in at least one class',
                ),
                _buildLegendItem(
                  context,
                  AttendanceStatus.late,
                  'Late to any class',
                ),
                _buildLegendItem(
                  context,
                  AttendanceStatus.partial,
                  'Partial attendance',
                ),
                _buildLegendItem(
                  context,
                  AttendanceStatus.holiday,
                  'Non-school day',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  Widget _buildLegendItem(
    BuildContext context,
    AttendanceStatus status,
    String description,
  ) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: _getStatusColor(colors, status),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.onSurface.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayTile extends StatelessWidget {
  final DateTime dayDate;
  final List<AttendancePeriod>? periods;
  final bool isToday;
  final ColorScheme colors;
  final TextTheme textTheme;

  const _DayTile({
    required this.dayDate,
    required this.periods,
    required this.isToday,
    required this.colors,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final isSchoolDay =
        dayDate.weekday >= DateTime.monday &&
        dayDate.weekday <= DateTime.friday;
    final status =
        periods == null
            ? AttendanceStatus.holiday
            : periods!.any((p) => p.status == AttendanceStatus.absent)
            ? AttendanceStatus.absent
            : AttendanceStatus.present;

    return GestureDetector(
      onTap: () => _showDailyDetails(context),
      child: Tooltip(
        message: _getTooltipMessage(),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _getStatusColor(colors, status),
            shape: BoxShape.circle,
            border:
                isToday
                    ? Border.all(color: colors.primary, width: 2)
                    : periods != null
                    ? Border.all(color: colors.outline.withOpacity(0.1))
                    : null,
            boxShadow:
                isToday
                    ? [
                      BoxShadow(
                        color: colors.primary.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ]
                    : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dayDate.day.toString(),
                style: textTheme.bodyMedium?.copyWith(
                  color: _getTextColor(colors, status),
                  fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                ),
              ),
              if (periods != null && periods!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Wrap(
                    spacing: 2,
                    children: [
                      for (final status in AttendanceStatus.values)
                        if (periods!.any((p) => p.status == status))
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: _getStatusDotColor(colors, status),
                              shape: BoxShape.circle,
                            ),
                          ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(ColorScheme colors, AttendanceStatus status) {
    return switch (status) {
      AttendanceStatus.present => colors.primary.withOpacity(0.2),
      AttendanceStatus.absent => colors.error.withOpacity(0.2),
      AttendanceStatus.late => colors.tertiary.withOpacity(0.2),
      AttendanceStatus.partial => colors.secondary.withOpacity(0.2),
      AttendanceStatus.holiday => colors.surfaceVariant.withOpacity(0.4),
    };
  }

  Color _getTextColor(ColorScheme colors, AttendanceStatus status) {
    return switch (status) {
      AttendanceStatus.present => colors.primary,
      AttendanceStatus.absent => colors.error,
      AttendanceStatus.late => colors.tertiary,
      AttendanceStatus.partial => colors.secondary,
      AttendanceStatus.holiday => colors.onSurfaceVariant,
    };
  }

  Color _getStatusDotColor(ColorScheme colors, AttendanceStatus status) {
    return switch (status) {
      AttendanceStatus.present => colors.primary,
      AttendanceStatus.absent => colors.error,
      AttendanceStatus.late => colors.tertiary,
      AttendanceStatus.partial => colors.secondary,
      AttendanceStatus.holiday => colors.outline,
    };
  }

  String _getTooltipMessage() {
    if (periods == null) return 'Non-school day';
    final presentCount =
        periods!.where((p) => p.status == AttendanceStatus.present).length;
    return '${presentCount}/${periods!.length} classes attended';
  }

  void _showDailyDetails(BuildContext context) {
    if (periods == null) return;

    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEEE, MMM d').format(dayDate),
                    style: textTheme.titleLarge?.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (periods!.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        'No attendance records',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    )
                  else
                    ...periods!
                        .map((period) => _PeriodRow(period: period))
                        .toList(),
                ],
              ),
            ),
          ),
    );
  }
}

class _PeriodRow extends StatelessWidget {
  final AttendancePeriod period;

  const _PeriodRow({required this.period});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _getStatusColor(colors, period.status).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              _getStatusIcon(period.status),
              size: 16,
              color: _getStatusColor(colors, period.status),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            DateFormat('HH:mm').format(period.time),
            style: textTheme.bodyMedium?.copyWith(
              color: colors.onSurface.withOpacity(0.8),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              period.courseName,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            period.status.name.toUpperCase(),
            style: textTheme.bodySmall?.copyWith(
              color: _getStatusColor(colors, period.status),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ColorScheme colors, AttendanceStatus status) {
    return switch (status) {
      AttendanceStatus.present => colors.primary,
      AttendanceStatus.absent => colors.error,
      AttendanceStatus.late => colors.tertiary,
      AttendanceStatus.partial => colors.secondary,
      AttendanceStatus.holiday => colors.outline,
    };
  }

  IconData _getStatusIcon(AttendanceStatus status) {
    return switch (status) {
      AttendanceStatus.present => Icons.check,
      AttendanceStatus.absent => Icons.close,
      AttendanceStatus.late => Icons.access_time,
      AttendanceStatus.partial => Icons.remove,
      AttendanceStatus.holiday => Icons.beach_access,
    };
  }
}

class AttendancePeriod {
  final DateTime time;
  final String courseName;
  final AttendanceStatus status;

  AttendancePeriod({
    required this.time,
    required this.courseName,
    required this.status,
  });
}

enum AttendanceStatus { present, absent, late, partial, holiday }
