import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pos_billing/common/singletons/app.dart';

Future<DateTimeRange?> showDateRangePickerDialogue({
  BuildContext? context,
  DateTimeRange? iniitalDateRange,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  DateTime fDate =
      (firstDate ??
      DateTime.now().subtract(const Duration(days: kDebugMode ? 1000 : 365)));
  DateTime lDate = (lastDate ?? DateTime.now());

  if (iniitalDateRange?.start != null &&
      iniitalDateRange!.start.isBefore(fDate)) {
    fDate = iniitalDateRange.start;
  }

  if (iniitalDateRange?.end != null && iniitalDateRange!.end.isAfter(lDate)) {
    lDate = iniitalDateRange.end;
  }

  return await showDateRangePicker(
    context: context ?? App.context,
    saveText: "Search",
    firstDate: fDate,
    lastDate: lDate,
    initialDateRange: iniitalDateRange,
    initialEntryMode: App.isDesktopDevice
        ? DatePickerEntryMode.inputOnly
        : DatePickerEntryMode.calendar,

    // builder: (context, child) {
    //   return Theme(
    //     data: Theme.of(Get.context!).copyWith(
    //       colorScheme: const ColorScheme.light(
    //         primary: kdprimarylightcolor,
    //         onPrimary: kdprimarycolor,
    //         onSurface: kdgreycolor,
    //       ),
    //       textButtonTheme: TextButtonThemeData(
    //         style: TextButton.styleFrom(
    //           foregroundColor: kdaccentcolor,
    //         ),
    //       ),
    //     ),
    //     child: child!,
    //   );
    // },
  );
}

Future<DateTimeRange?> showDateTimeRangePickerDialogue({
  DateTimeRange? iniitalDateRange,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  firstDate ??= DateTime.now().subtract(
    const Duration(days: kDebugMode ? 1000 : 365),
  );

  lastDate ??= DateTime.now();

  if (iniitalDateRange?.start != null &&
      iniitalDateRange!.start.isBefore(firstDate)) {
    firstDate = iniitalDateRange.start;
  }

  if (iniitalDateRange?.end != null &&
      iniitalDateRange!.end.isAfter(lastDate)) {
    lastDate = iniitalDateRange.end;
  }

  final d0 = await _picDateAndTime(
    helpText: "From",
    initialDate: iniitalDateRange?.start,
    firstDate: firstDate,
    lastDate: lastDate,
  );
  if (d0 == null) {
    return null;
  }

  DateTime? initialDate1 =
      d0.millisecondsSinceEpoch >
          (iniitalDateRange?.end.millisecondsSinceEpoch ?? 0)
      ? d0
      : iniitalDateRange?.end;

  final d1 = await _picDateAndTime(
    helpText: "Till",
    initialDate: initialDate1,
    firstDate: d0,
    lastDate: lastDate,
  );
  if (d1 == null) {
    return null;
  }

  return DateTimeRange(start: d0, end: d1);
}

Future<DateTime?> _picDateAndTime({
  required String helpText,
  required DateTime? initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  final context = App.context;

  final d0 = await showDatePicker(
    helpText: "$helpText Date",
    context: context,
    confirmText: "Next",
    firstDate: firstDate,
    lastDate: lastDate,
    initialDate: initialDate,
    // initialEntryMode: DatePickerEntryMode.calendarOnly,
    initialEntryMode: App.isDesktopDevice
        ? DatePickerEntryMode.inputOnly
        : DatePickerEntryMode.calendarOnly,
  );

  if (d0 == null) {
    return null;
  }

  final t0 = await showTimePicker(
    context: context,
    helpText: "$helpText Time",
    initialTime: initialDate != null
        ? TimeOfDay?.fromDateTime(initialDate)
        : TimeOfDay.now(),
    initialEntryMode: TimePickerEntryMode.inputOnly,

    confirmText: "Done",
  );

  if (t0 == null) {
    return null;
  }

  return DateTime(d0.year, d0.month, d0.day, t0.hour, t0.minute);
}
