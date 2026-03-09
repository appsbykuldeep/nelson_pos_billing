import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';

AppUpdateInfo? _status;

Future<void> checkForUpdate() async {
  if (!kReleaseMode || 1 == 1) return;

  try {
    _status ??= await InAppUpdate.checkForUpdate();

    if (_status != null &&
        _status!.updateAvailability == UpdateAvailability.updateAvailable) {
      await InAppUpdate.performImmediateUpdate();
    }
  } catch (e) {
    debugPrint("checkForUpdate : $e");
  }
}
