import 'package:flutter/material.dart';

enum PaymentMode {
  none(id: -1, lable: "None", iconData: Icons.pending),
  cash(id: 0, lable: "Cash", iconData: Icons.payments),
  online(id: 1, lable: "Online", iconData: Icons.account_balance_wallet),
  rfidCard(id: 2, lable: "RFID Card", iconData: Icons.sensors);

  final int id;
  final String lable;
  final IconData iconData;

  factory PaymentMode.byIdOrCash(int id) => switch (id) {
    0 => PaymentMode.cash,
    1 => PaymentMode.online,
    2 => PaymentMode.rfidCard,
    _ => PaymentMode.cash,
  };

  factory PaymentMode.byId(int id) => switch (id) {
    0 => PaymentMode.cash,
    1 => PaymentMode.online,
    2 => PaymentMode.rfidCard,
    _ => PaymentMode.none,
  };

  factory PaymentMode.byIdDefCash(int? id) => switch (id) {
    0 => PaymentMode.cash,
    1 => PaymentMode.online,
    2 => PaymentMode.rfidCard,
    _ => PaymentMode.cash,
  };

  factory PaymentMode.byTextId(String id) =>
      PaymentMode.byId(int.tryParse(id) ?? 0);

  static List<PaymentMode> allModes = [cash, online];
  // static List<PaymentMode> allModes = [cash, online, rfidCard];

  bool get isnone => this == none;
  bool get iscash => this == cash;
  bool get isonline => this == online;
  bool get isrfidCard => this == rfidCard;

  const PaymentMode({
    required this.id,
    required this.lable,
    required this.iconData,
  });
}
