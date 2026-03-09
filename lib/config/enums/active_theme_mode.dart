import 'package:flutter/material.dart';

enum ActiveThemeMode {
  light("Light Theme", "LT", Icons.light_mode),
  dark("Dark Theme", "DK", Icons.dark_mode);

  final String lable;
  final String id;
  final IconData iconData;
  const ActiveThemeMode(this.lable, this.id, this.iconData);

  factory ActiveThemeMode.byId(String id) => switch (id) {
    "DK" => ActiveThemeMode.dark,
    _ => ActiveThemeMode.light,
  };

  bool get islight => this == light;
  bool get isdark => this == dark;
}
