// ignore_for_file: avoid_print

import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';

class TimeLaps {
  final String tag;
  TimeLaps({required this.tag});
  final List<DateTime> _lapList = [DateTime.now()];
  DateTime get _lastLaps => _lapList.last;
  int _count = 1;

  void _printText(dynamic text) {
    if (1 == 0) {
      print(text);
      return;
    }
    dev.log(text);
  }

  void laps([String? lapsTag]) {
    if (!kDebugMode) return;
    final now = DateTime.now();
    _printText(
      "$tag $_count ${lapsTag ?? ''}:: ${now.difference(_lastLaps).inMilliseconds} mili",
    );
    _lapList.add(now);
    _count++;
  }

  void overAll() {
    if (!kDebugMode) return;
    final now = _lapList.first;
    _printText(
      "$tag's overAll  :: ${_lastLaps.difference(now).inMilliseconds} mili",
    );
  }
}
