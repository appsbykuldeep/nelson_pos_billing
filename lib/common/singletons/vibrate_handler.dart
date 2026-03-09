import 'dart:async';

import 'package:pos_billing/common/abstract_classes/initialized_class.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:vibration/vibration.dart';

class VibrateHandler implements InitializedClass {
  VibrateHandler._();

  static final VibrateHandler _instance = VibrateHandler._();

  static VibrateHandler get instance => _instance;

  bool _canVibrate = false;

  static Future<void> vibrate({
    int msDuration = 500,
    List<int> pattern = const [],
  }) async {
    if (_instance._canVibrate) {
      await Vibration.vibrate(duration: msDuration, pattern: pattern);
    }
  }

  static Future<void> captured() async {
    vibrate(msDuration: 50);
  }

  static Future<void> error() async {
    vibrate(pattern: [5, 250, 50, 250]);
  }

  static Future<void> warning() async {
    vibrate(pattern: [5, 150, 50, 150]);
  }

  static Future<void> testAll() async {
    final all = [error];
    for (var func in all) {
      await func.call();
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  @override
  FutureOr<void> initialized() async {
    if (App.isNotMobileDevice) return;
    try {
      _canVibrate = (await Vibration.hasVibrator());
    } catch (e) {
      _canVibrate = false;
    }
  }
}
