import 'dart:io';

import 'package:flutter/foundation.dart';

import 'move_app_background_platform_interface.dart';

class MoveAppBackground {
  static Future<String?> getPlatformVersion() {
    return MoveAppBackgroundPlatform.instance.getPlatformVersion();
  }

  static Future<bool> onWillPop() async {
    if (!kIsWeb && Platform.isAndroid) {
      return (!await move());
    } else {
      return true;
    }
  }

  static Future<bool> move() {
    return MoveAppBackgroundPlatform.instance.move();
  }
}
