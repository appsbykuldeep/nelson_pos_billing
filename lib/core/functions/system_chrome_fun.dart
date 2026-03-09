import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// fullScreenMode() {
//   hideStatusBar();
//   // SystemChrome.setEnabledSystemUIMode(
//   //   SystemUiMode.immersiveSticky,
//   //   overlays: [SystemUiOverlay.bottom],
//   // );

//   // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
//   //     overlays: [SystemUiOverlay.bottom]);
// }

// hideStatusBar() {
//   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//     systemNavigationBarColor: Colors.transparent, // navigation bar color
//     statusBarColor: Colors.transparent, // status bar color
//   ));
//   // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
//   //     overlays: [SystemUiOverlay.bottom]);
// }

void hideStatusBar() {
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom],
  );
}

void showStatusBar() {
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );
}

void fullScreenMode() {
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

void transparentAppbar([bool isDarkTheme = false]) {
  final brightness = isDarkTheme ? Brightness.light : Brightness.dark;
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Makes the status bar transparent
      systemNavigationBarColor: Colors.transparent,
      statusBarBrightness: brightness, // For Android (light/dark icons)
      statusBarIconBrightness: brightness, // For iOS (light/dark icons)
    ),
  );
}

void ensureEdgeToEdge() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}
