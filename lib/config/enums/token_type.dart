import 'package:pos_billing/common/models/basic/site_detail_model.dart';

enum TokenType {
  dateWise(1, "Daily"),
  monthly(2, "Monthly"),
  quarterly(3, "Quarterly"),
  yearly(4, "yearly"),
  financialyear(5, "Financial Year");

  final int id;
  final String label;

  const TokenType(this.id, this.label);

  String getTokenDate({required TokenDateConfig dateConfig}) {
    final now = DateTime.now();
    DateTime resultDate = switch (this) {
      monthly => _getCustomMonthStart(now, dateConfig.monthStartDay),
      quarterly => _getCustomQuarterStart(
        now,
        dateConfig.quarterStartDay,
        dateConfig.quarterStartMonth,
      ),
      yearly => _getCustomYearStart(
        now,
        dateConfig.yearStartDay,
        dateConfig.yearStartMonth,
      ),
      financialyear => _getCustomFinancialYearStart(
        now,
        dateConfig.fyStartDay,
        dateConfig.fyStartMonth,
      ),
      _ => now,
    };

    return _formatDate(resultDate);
  }

  String _formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

  factory TokenType.parse(dynamic key) => switch (key) {
    1 => dateWise,
    2 => monthly,
    3 => quarterly,
    4 => yearly,
    5 => financialyear,

    "1" => dateWise,
    "2" => monthly,
    "3" => quarterly,
    "4" => yearly,
    "5" => financialyear,

    _ => dateWise,
  };
}

DateTime _getCustomMonthStart(DateTime now, int startDay) {
  if (now.day >= startDay) {
    return DateTime(now.year, now.month, startDay);
  } else {
    DateTime prevMonth = DateTime(now.year, now.month - 1, 1);
    return DateTime(prevMonth.year, prevMonth.month, startDay);
  }
}

DateTime _getCustomQuarterStart(DateTime now, int startDay, int startMonth) {
  int monthsDiff = (now.year * 12 + now.month) - (now.year * 12 + startMonth);

  int quarterIndex = monthsDiff ~/ 3;

  int quarterStartMonth = startMonth + (quarterIndex * 3);

  int yearAdjustment = (quarterStartMonth - 1) ~/ 12;
  quarterStartMonth = ((quarterStartMonth - 1) % 12) + 1;

  int year = now.year + yearAdjustment;

  DateTime candidate = DateTime(year, quarterStartMonth, startDay);

  if (candidate.isAfter(now)) {
    return _getCustomQuarterStart(
      DateTime(now.year, now.month - 3, now.day),
      startDay,
      startMonth,
    );
  }

  return candidate;
}

DateTime _getCustomYearStart(DateTime now, int startDay, int startMonth) {
  DateTime candidate = DateTime(now.year, startMonth, startDay);

  if (now.isBefore(candidate)) {
    return DateTime(now.year - 1, startMonth, startDay);
  }

  return candidate;
}

DateTime _getCustomFinancialYearStart(
  DateTime now,
  int startDay,
  int startMonth,
) {
  DateTime candidate = DateTime(now.year, startMonth, startDay);

  if (now.isBefore(candidate)) {
    return DateTime(now.year - 1, startMonth, startDay);
  }

  return candidate;
}
