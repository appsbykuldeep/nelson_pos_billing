import 'package:flutter/services.dart';

void portraitModeOnly() {
  if (1 == 1) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
    ]);
  }
}

void landscapeModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    // DeviceOrientation.landscapeRight,
  ]);
}
