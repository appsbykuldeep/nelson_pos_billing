import 'package:flutter/material.dart';

enum ExternalDeviceType {
  none(id: 0, priority: 0, iconData: Icons.bluetooth),

  bluetoothMobilePrinter(id: 1, priority: 0, iconData: Icons.bluetooth),
  bleMobilePrinter(id: 2, priority: 0, iconData: Icons.bluetooth),
  usbMobilePrinter(id: 3, priority: 0, iconData: Icons.usb),
  networkMobilePrinter(id: 4, priority: 0, iconData: Icons.wifi),

  bluetoothWindowsPrinter(id: 5, priority: 0, iconData: Icons.bluetooth),
  bleWindowsPrinter(id: 6, priority: 0, iconData: Icons.bluetooth),
  usbWindowsPrinter(id: 7, priority: 0, iconData: Icons.usb),
  networkWindowsPrinter(id: 8, priority: 0, iconData: Icons.wifi),

  bluetoothWebPrinter(id: 9, priority: 0, iconData: Icons.bluetooth),
  bleWebPrinter(id: 10, priority: 0, iconData: Icons.bluetooth),
  usbWebPrinter(id: 11, priority: 0, iconData: Icons.usb),
  networkWebPrinter(id: 12, priority: 0, iconData: Icons.wifi),

  bleBarrier(id: 13, priority: 0, iconData: Icons.local_parking);

  final int id;
  final double priority;
  final IconData iconData;

  const ExternalDeviceType({
    required this.id,
    required this.priority,
    required this.iconData,
  });

  factory ExternalDeviceType.byId(int id) {
    for (var e in ExternalDeviceType.values) {
      if (e.id == id) {
        return e;
      }
    }

    return ExternalDeviceType.none;
  }

  bool get isNone => this == none;
  bool get isbluetoothMobilePrinter => this == bluetoothMobilePrinter;
  bool get isbleMobilePrinter => this == bleMobilePrinter;
  bool get isusbMobilePrinter => this == usbMobilePrinter;
  bool get isnetworkMobilePrinter => this == networkMobilePrinter;
  bool get isbluetoothWindowsPrinter => this == bluetoothWindowsPrinter;
  bool get isbleWindowsPrinter => this == bleWindowsPrinter;
  bool get isusbWindowsPrinter => this == usbWindowsPrinter;
  bool get isnetworkWindowsPrinter => this == networkWindowsPrinter;
  bool get isbluetoothWebPrinter => this == bluetoothWebPrinter;
  bool get isbleWebPrinter => this == bleWebPrinter;
  bool get isusbWebPrinter => this == usbWebPrinter;
  bool get isnetworkWebPrinter => this == networkWebPrinter;
  bool get isbleBarrier => this == bleBarrier;

  bool get isBluetoothDevice => [
    bluetoothMobilePrinter,
    bluetoothWindowsPrinter,
    bluetoothWebPrinter,
  ].contains(this);
  bool get isBleDevice => [
    bleMobilePrinter,
    bleWindowsPrinter,
    bleWebPrinter,
    bleBarrier,
  ].contains(this);
  bool get isUsbDevice =>
      [usbMobilePrinter, usbWindowsPrinter, usbWebPrinter].contains(this);
  bool get isNetworkDevice => [
    networkMobilePrinter,
    networkWindowsPrinter,
    networkWebPrinter,
  ].contains(this);
}
