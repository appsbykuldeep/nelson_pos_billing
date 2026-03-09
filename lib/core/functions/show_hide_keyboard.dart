import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void hideKeyboard() {
  if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
