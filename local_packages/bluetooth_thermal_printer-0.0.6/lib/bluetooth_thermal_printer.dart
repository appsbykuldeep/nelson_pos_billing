import 'dart:async';

import 'package:bluetooth_thermal_printer/blue_device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BluetoothThermalPrinter {
  static const MethodChannel _channel =
      MethodChannel('bluetooth_thermal_printer');

  static const _eventChannel = EventChannel('bluetooth_thermal_printer_event');

  static Stream<dynamic> listen() {
    return _eventChannel.receiveBroadcastStream();
  }

  /// Get android platform version.
  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Get list of all paired bluetooth devices
  static Future<List<BlueDeviceInfo>> get getBluetooths async {
    List<BlueDeviceInfo> items = <BlueDeviceInfo>[];
    try {
      final List? result = await _channel.invokeMethod('bluetothLinked');
      items = BlueDeviceInfo.fetchList(result);
      items.sort(
          (a, b) => b.deviceType.priority.compareTo(a.deviceType.priority));
    } on PlatformException catch (e) {
      debugPrint("Bluetooth paired failure: '${e.message}'.");
    }

    return items;
  }

  /// Get bluetooth device connection status
  static Future<String?> get connectionStatus async {
    try {
      final String? result = await _channel.invokeMethod('connectionStatus');
      return result;
    } on PlatformException catch (e) {
      debugPrint("Failed to write bytes: '${e.message}'.");
      return "false";
    }
  }

  /// Connect to device using [mac].
  static Future<String?> connect(String mac) async {
    String? result = "false";
    try {
      result = await _channel
          .invokeMethod('connectPrinter', mac)
          .timeout(const Duration(seconds: 20));
    } on PlatformException catch (e) {
      debugPrint("Failed to connect: '${e.message}'.");
      return null;
    }
    return result;
  }

  /// Connect to device using [mac].
  static Future<String?> disconnect() async {
    String? result = "false";
    try {
      result = await _channel.invokeMethod(
        'disconnectPrinter',
      );
    } on PlatformException catch (e) {
      debugPrint("Failed to connect: '${e.message}'.");
      return null;
    }
    return result;
  }

  static Future<String?> closetPrinter() async {
    String? result = "false";
    try {
      result = await _channel.invokeMethod(
        'closetPrinter',
      );
    } on PlatformException catch (e) {
      debugPrint("Failed to connect: '${e.message}'.");
      return null;
    }
    return result;
  }

  ///Printes the [bytes] using bluetooth printer.
  static Future<String?> writeBytes(List<int> bytes) async {
    try {
      final String? result = await _channel.invokeMethod('writeBytes', bytes);
      return result;
    } on PlatformException catch (e) {
      debugPrint("Failed to write bytes: '${e.message}'.");
      return "false";
    }
  }

  ///Printes the [text] using bluetooth printer.
  static Future<String?> writeText(String text) async {
    try {
      final String? result = await _channel.invokeMethod('printText', text);
      return result;
    } on PlatformException catch (e) {
      debugPrint("Failed to writeText: '${e.message}'.");
      return "false";
    }
  }

  /// Get battery level of the android device.
  static Future<int?> get getBatteryLevel async {
    try {
      final int? result = await _channel.invokeMethod('getBatteryLevel');
      return result;
    } on PlatformException catch (e) {
      debugPrint("Failed to get battery level: '${e.message}'.");
      return -1;
    }
  }
}
