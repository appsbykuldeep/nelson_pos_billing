import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pos_billing/common/abstract_classes/initialized_class.dart';

class AppClock implements InitializedClass, DisposeClass {
  ValueNotifier<DateTime> currentStampNotifier = ValueNotifier(DateTime.now());

  Timer? _timer;

  @override
  FutureOr<void> dispose() {
    _timer?.cancel();
    currentStampNotifier.dispose();
  }

  @override
  FutureOr<void> initialized() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      currentStampNotifier.value = DateTime.now();
    });
  }
}
