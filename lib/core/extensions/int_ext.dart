import 'package:flutter/material.dart';

extension AppIntExt on int {
  /// This will convert `minute` into `(int day, int hour, int minute)`
  (int d, int h, int m) minuteToDDHHMM() {
    int d, h, m;
    d = this ~/ 1440;
    h = (this - d * 1440) ~/ 60;
    m = ((this - (d * 1440 + h * 60)));

    return (d, h, m);
  }

  /// This will convert `minute` into `(int hour, int minute)`
  (int h, int m) minuteToHHMM() {
    int h, m;
    h = this ~/ 60;
    m = ((this - (h * 60)));

    return (h, m);
  }

  (int, int, int) secondToHHMMSS() {
    Duration duration = Duration(seconds: this);
    int h = duration.inHours;
    int m = duration.inMinutes.remainder(60);
    int s = duration.inSeconds.remainder(60);

    return (h, m, s);
  }

  TimeOfDay minuteToTimeOfDay() {
    final (d, h, m) = minuteToDDHHMM();
    return TimeOfDay(hour: h, minute: m);
  }

  String minuteTo12HourTime() {
    final (d, h, m) = minuteToDDHHMM();
    final period = h >= 12 ? 'PM' : 'AM';
    final hours12 = h % 12 == 0 ? 12 : h % 12;
    return '${hours12.toString().padLeft(2, '0')}:'
        '${m.toString().padLeft(2, '0')} $period';
  }
}
