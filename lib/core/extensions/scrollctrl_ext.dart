import 'package:flutter/material.dart';

extension AppScrollController on ScrollController {
  void animateToTop() {
    animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }
}
