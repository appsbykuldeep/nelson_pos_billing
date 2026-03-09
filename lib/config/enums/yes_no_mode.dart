import 'package:flutter/material.dart';

enum YesNoMode {
  yes("Yes", "y", Icons.done, Colors.green),
  no("No", "n", Icons.close, Colors.red);

  final String lable;
  final String id;
  final IconData iconData;
  final Color color;
  const YesNoMode(this.lable, this.id, this.iconData, this.color);

  factory YesNoMode.byId(String id) => switch (id) {
    "y" => YesNoMode.yes,
    "n" => YesNoMode.no,
    _ => YesNoMode.yes,
  };

  factory YesNoMode.byIdAndDef(String id, {YesNoMode def = YesNoMode.yes}) =>
      switch (id) {
        "y" => YesNoMode.yes,
        "n" => YesNoMode.no,
        _ => def,
      };

  YesNoMode toggle() => isyes ? no : yes;

  bool get isyes => this == yes;
  bool get isno => this == no;
}
