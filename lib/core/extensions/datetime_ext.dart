import 'package:pos_billing/common/singletons/dateformat_handler.dart';
import 'package:pos_billing/config/constants/app_constants.dart';

final Duration _timeZoneOffset = DateTime.now().timeZoneOffset;
final bool _isIndia = _timeZoneOffset.inMinutes == 330;

extension AppDateTimeExt on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);
  DateTime get dateTillMin => DateTime(year, month, day, hour, minute);
  DateTime get removeMili => DateTime(year, month, day, hour, minute, second);

  DateTime get monthFirstDate => DateTime(year, month);
  DateTime get monthLastDate => DateTime(year, month + 1, 0);

  DateTime get toDayStartDateTime => DateTime(year, month, day);
  DateTime get toDayendDateTime => DateTime(year, month, day, 23, 59);

  bool get haveTime => minute > 0 || second > 0;

  bool get isToday {
    final n = DateTime.now();
    return (year == n.year && month == n.month && day == n.day);
  }

  bool isSameDate(DateTime other) {
    return (year == other.year && month == other.month && day == other.day);
  }

  bool isSameDateTime(DateTime other) {
    return (year == other.year &&
        month == other.month &&
        day == other.day &&
        hour == other.hour &&
        minute == other.minute &&
        second == other.second);
  }

  bool get isYesterday {
    final n = DateTime.now();
    return (year == n.year && month == n.month && day == (n.day - 1));
  }

  // bool get _isIndia => timeZoneOffset.inMinutes == 330;
  // bool get _isIndia => DateTime.now().timeZoneOffset.inMinutes == 330;

  // DateTime get toINDDate {
  //   // && timeZoneOffset.inMinutes == 330
  //   if (_isIndia) {
  //     return this;
  //   } else {
  //     final ind = toUtc().add(diffIndiaUTC);

  //     return DateTime(ind.year, ind.month, ind.day);
  //   }
  // }

  DateTime get toINDDateTime {
    if (_isIndia) {
      return this;
    } else {
      // final ind = subtract(timeZoneOffset).add(diffIndiaUTC);
      final ind = toUtc().add(diffIndiaUTC);

      return DateTime(
        ind.year,
        ind.month,
        ind.day,
        ind.hour,
        ind.minute,
        ind.second,
      );
    }
  }

  DateTime fromIndianToLocal() {
    if (_isIndia) {
      return this;
    } else {
      return subtract(
        const Duration(hours: 5, minutes: 30),
      ).add(_timeZoneOffset);
    }
  }

  DateTime addDay(int d) => add(Duration(days: d));
  DateTime subDay(int d) => subtract(Duration(days: d));

  String formatESTTime(DateTime since) {
    if (isSameDate(since)) {
      return custumDateFormat('hh:mm:ss a');
    }

    return custumDateFormat('dd-MMM-yyy hh:mm:ss a');
  }

  String formatFromSinceDate(DateTime since) {
    if (isSameDate(since)) {
      return custumDateFormat('hh:mm a');
    }

    return custumDateFormat('dd-MMM-yyy hh:mm a');
  }

  String get dateVibleDate => custumDateFormat('dd-MMM-yyy');
  String get visibleTime => custumDateFormat('hh:mm a');
  String get dateVibleDateStamp => custumDateFormat('dd-MMM-yyy hh:mm:ss a');
  String get dateVibleDateStampTillSec =>
      custumDateFormat('dd-MMM-yyy hh:mm:ss a');
  String get fromdateFormat => custumDateFormat('yyyy-MM-dd 00:00:00');
  String get tilldateFormat => custumDateFormat('yyyy-MM-dd 23:59:59');
  String get dateStanderedFormat => custumDateFormat('yyyy-MM-dd');

  String get fileNameDateTime => custumDateFormat("ddMMMyyy hh.mm.ss a");

  String get printableDateTimeformat => custumDateFormat("dd.MMM.yyy hh:mma");
  String get dateTimePickerFormat => custumDateFormat("dd-MM-yyyy HH:mm");

  String get dateTimeStanderedFormat => custumDateFormat('yyyy-MM-dd HH:mm:ss');
  String custumDateFormat(String format) =>
      DateformatHandler.formatDateTime(this, format);

  String appTimeAgo() {
    if (isToday) return "Today";
    if (isYesterday) return "Yesterday";
    final d = DateTime.now().difference(this).inDays;
    return "$d Days";
  }

  /// apply on issue datetime
  double getRemainingDurationInPercent(DateTime? passExpireOn) {
    if (passExpireOn == null) return 0; // no expiry = 0% remaining

    final totalDuration = passExpireOn.difference(this).inSeconds;
    final usedDuration = DateTime.now().difference(this).inSeconds;

    if (totalDuration <= 0) return 0; // invalid case
    if (usedDuration >= totalDuration) return 0; // already expired

    final remaining = totalDuration - usedDuration;
    return (remaining / totalDuration);
  }
}
