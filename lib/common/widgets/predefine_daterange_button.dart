import 'package:flutter/material.dart';
import 'package:pos_billing/core/extensions/datetime_ext.dart';

class PredefineDaterangeButton extends StatefulWidget {
  final ValueChanged<DateTimeRange> onTapAny;

  const PredefineDaterangeButton({super.key, required this.onTapAny});

  @override
  State<PredefineDaterangeButton> createState() =>
      _PredefineDaterangeButtonState();
}

class _PredefineDaterangeButtonState extends State<PredefineDaterangeButton> {
  DateTime get dateOnly => DateTime.now().dateOnly;

  ScrollController controller = ScrollController();

  DateTimeRange getThisWeekRange() {
    final int weekStartDay = DateTime.sunday;

    final now = DateTime.now();

    // Dart weekday: Monday = 1, ..., Sunday = 7
    int currentWeekday = now.weekday;

    // How many days to go backwards to reach the start of week
    int diff = currentWeekday - weekStartDay;

    // Adjust if negative (e.g., weekStart = Sunday = 7)
    if (diff < 0) diff += 7;

    final start = now.subtract(Duration(days: diff));
    final end = start.add(const Duration(days: 6));
    return DateTimeRange(start: start, end: end);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: Scrollbar(
        controller: controller,
        child: SingleChildScrollView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Row(
            spacing: 16,
            children: [
              _PreDateButton(
                color: Colors.blue.shade800,
                text: "Today",
                onTap: () {
                  final now = dateOnly;
                  widget.onTapAny.call(DateTimeRange(start: now, end: now));
                },
              ),
              _PreDateButton(
                color: Colors.grey.shade800,
                text: "Yesterday",
                onTap: () {
                  final yesterday = dateOnly.subtract(const Duration(days: 1));
                  widget.onTapAny.call(
                    DateTimeRange(start: yesterday, end: yesterday),
                  );
                },
              ),
              _PreDateButton(
                color: Colors.green.shade800,
                text: "This Week",
                onTap: () {
                  widget.onTapAny.call(getThisWeekRange());
                },
              ),
              _PreDateButton(
                color: Colors.cyan.shade800,
                text: "Last Week",
                onTap: () {
                  final thisWeek = getThisWeekRange();
                  widget.onTapAny.call(
                    DateTimeRange(
                      start: thisWeek.start.subtract(const Duration(days: 7)),
                      end: thisWeek.end.subtract(const Duration(days: 7)),
                    ),
                  );
                },
              ),
              _PreDateButton(
                color: Colors.red.shade800,
                text: "This Month",
                onTap: () {
                  final now = dateOnly;
                  final start = DateTime(now.year, now.month, 1);
                  final end = DateTime(now.year, now.month + 1, 0);
                  widget.onTapAny.call(DateTimeRange(start: start, end: end));
                },
              ),
              _PreDateButton(
                color: Colors.blueAccent,
                text: "Last Month",
                onTap: () {
                  final now = dateOnly;
                  final start = DateTime(now.year, now.month - 1, 1);
                  final end = DateTime(now.year, now.month, 0);
                  widget.onTapAny.call(DateTimeRange(start: start, end: end));
                },
              ),
              _PreDateButton(
                color: Colors.amber.shade800,
                text: "This Year",
                onTap: () {
                  final now = dateOnly;
                  final int year = now.year;

                  final start = DateTime(year, 1, 1);
                  final end = DateTime(year, 12, 31);
                  widget.onTapAny.call(DateTimeRange(start: start, end: end));
                },
              ),
              _PreDateButton(
                color: Colors.brown.shade800,
                text: "Last Year",
                onTap: () {
                  final now = dateOnly;
                  final int lastYear = now.year - 1;

                  final start = DateTime(lastYear, 1, 1);
                  final end = DateTime(lastYear, 12, 31);
                  widget.onTapAny.call(DateTimeRange(start: start, end: end));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreDateButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;
  const _PreDateButton({
    required this.text,
    required this.color,

    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (1 == 0) {
      final theme = Theme.of(context);
      final primary = theme.primaryColor;
      return Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 1, color: primary),
            ),

            child: Text(
              text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    }
    return FilledButton(
      style: FilledButton.styleFrom(backgroundColor: color),
      onPressed: onTap,
      child: Text(text),
    );
  }
}
