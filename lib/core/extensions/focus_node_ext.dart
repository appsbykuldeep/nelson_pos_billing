import 'package:flutter/material.dart';

extension AppFocusNodeExt on FocusNode {
  void getFocus() {
    if (!hasFocus) {
      requestFocus();
    }
  }

  Future<void> getFocusAfert({
    Duration duration = const Duration(milliseconds: 300),
  }) async {
    await Future.delayed(duration);
    getFocus();
    await Future.delayed(const Duration(milliseconds: 5));
  }
}
