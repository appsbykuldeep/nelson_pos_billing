import 'package:flutter/material.dart';
import 'package:pos_billing/core/extensions/datetime_ext.dart';

extension KdDateTimeRangeExt on DateTimeRange {
  String get dateRangeText {
    if (start.day == end.day &&
        start.month == end.month &&
        start.year == end.year) {
      return "(${start.dateStanderedFormat})";
    }
    return "(${start.dateVibleDate} to ${end.dateVibleDate})";
  }

  (String, String?) get dateRangePartsText {
    if (start.day == end.day &&
        start.month == end.month &&
        start.year == end.year) {
      return (start.dateVibleDate, null);
    }
    return (start.dateVibleDate, end.dateVibleDate);
  }

  (String, String?) get dateTimeRangePartsText {
    if (start.day == end.day &&
        start.month == end.month &&
        start.year == end.year &&
        start.hour == end.hour &&
        start.minute == end.minute) {
      return (start.dateVibleDateStamp, null);
    }
    return (start.dateVibleDateStamp, end.dateVibleDateStamp);
  }
}
