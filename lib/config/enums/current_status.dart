import 'package:flutter/material.dart';

/// In some place (Where only 2 case created active/deleted) [0,1] both use for active
enum CurrentStatus {
  inactive(0, "Inactive", Icons.toggle_on, Colors.amber),
  active(1, "Active", Icons.toggle_on, Colors.green),
  deleted(2, "Deleted", Icons.delete, Colors.red);

  final int id;
  final String lable;
  final IconData iconData;
  final Color color;
  const CurrentStatus(this.id, this.lable, this.iconData, this.color);

  factory CurrentStatus.byId(int id) => switch (id) {
    0 => CurrentStatus.inactive,
    2 => CurrentStatus.deleted,
    _ => CurrentStatus.active,
  };

  bool get isInactive => this == inactive;
  bool get isActive => this == active;
  bool get isDeleted => this == deleted;

  static List<CurrentStatus> activeInactive = [active, inactive];
}
