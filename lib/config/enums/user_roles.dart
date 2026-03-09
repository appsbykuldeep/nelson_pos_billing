import 'package:flutter/material.dart';

enum UserRole {
  none(0, 'None', Icons.note_outlined, '🚫', -1),
  company(1, 'Company', Icons.business_center_outlined, '🏢', 1),
  owner(2, 'Owner', Icons.account_circle_outlined, '🧑‍💻', 2),
  admin(3, 'Admin', Icons.account_circle_outlined, '🧑‍💻', 3),
  staff(4, 'Staff', Icons.badge_outlined, '🧑‍💼', 5),
  system(5, 'System', Icons.computer, '🧑‍💻', 3);

  final int id;
  final String lable;
  final IconData icon;
  final String emoji;
  final double priorityLevel;

  const UserRole(
    this.id,
    this.lable,
    this.icon,
    this.emoji,
    this.priorityLevel,
  );

  bool get isNone => this == none;
  bool get isOwner => this == owner;
  bool get isStaff => this == staff;
  bool get iscompany => this == company;
  bool get isstandAdmin => this == admin;

  bool get isOwnerOrAdmin => [owner, admin].contains(this);

  factory UserRole.byValue(dynamic value) => switch (value) {
    // name
    "Owner" => UserRole.owner,
    "Staff" => UserRole.staff,
    "Company" => UserRole.company,
    "Admin" => UserRole.admin,
    // name lower
    "owner" => UserRole.owner,
    "staff" => UserRole.staff,
    "company" => UserRole.company,
    "admin" => UserRole.admin,

    // id String
    "1" => UserRole.company,
    "2" => UserRole.owner,
    "3" => UserRole.admin,
    "4" => UserRole.staff,
    "5" => UserRole.staff,

    // id int
    1 => UserRole.company,
    2 => UserRole.owner,
    3 => UserRole.admin,
    4 => UserRole.staff,
    5 => UserRole.staff,

    _ => UserRole.none,
  };
}
