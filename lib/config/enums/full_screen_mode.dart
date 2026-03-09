import 'package:flutter/material.dart';

enum FullScreenMode {
  on("On", "y", Icons.open_in_full),
  off("Off", "n", Icons.close_fullscreen);

  final String label;
  final String id;
  final IconData iconData;
  const FullScreenMode(this.label, this.id, this.iconData);

  factory FullScreenMode.byId(String id) => switch (id) {
    "y" => FullScreenMode.on,
    "n" => FullScreenMode.off,
    _ => FullScreenMode.off,
  };

  bool get ison => this == on;
  bool get isoff => this == off;
}
