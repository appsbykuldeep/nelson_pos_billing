import 'package:flutter/material.dart';

class BlueDeviceInfo {
  final String name;
  final String address;
  final int deviceTypeId;
  final int majorDeviceClassId;
  final int deviceClassId;
  final BlueDeviceType deviceType;

  bool isConnected;

  BlueDeviceInfo({
    this.name = "",
    this.address = "",
    this.deviceTypeId = 0,
    this.majorDeviceClassId = 0,
    this.deviceClassId = 0,
    this.deviceType = BlueDeviceType.unknown,
    this.isConnected = false,
  });

  late final bool isprinter = deviceType.isPrinter;

  static List<BlueDeviceInfo> fetchList(dynamic data) {
    try {
      if (data is List) {
        return List<BlueDeviceInfo>.from(
          data.map(
            (e) => BlueDeviceInfo.fromJson(_convertMap(e)),
          ),
        );
      }
    } catch (e) {
      return [];
    }

    return [];
  }

  static Map<String, dynamic> _convertMap(dynamic data) {
    Map<String, dynamic> output = {};
    if (data is Map) {
      for (var x in data.entries) {
        output[x.key.toString()] = x.value;
      }
    }

    return output;
  }

  factory BlueDeviceInfo.fromJson(Map<String, dynamic> json) {
    final deviceType = json["deviceType"] ?? 0;
    final majorDeviceClass = json["majorDeviceClass"] ?? 0;
    final deviceClass = json["deviceClass"] ?? 0;
    final deviceName = json["deviceName"] ?? "";
    return BlueDeviceInfo(
      name: deviceName,
      address: json["address"] ?? "",
      deviceTypeId: deviceType,
      majorDeviceClassId: majorDeviceClass,
      deviceClassId: deviceClass,
      deviceType: _parseDeviceType(
          deviceName: deviceName,
          deviceType: deviceType,
          majorDeviceClass: majorDeviceClass,
          deviceClass: deviceClass),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BlueDeviceInfo && other.address == address;
  }

  @override
  int get hashCode {
    return address.hashCode;
  }
}

// https://developer.android.com/reference/kotlin/android/bluetooth/BluetoothClass.Device.Major#imaging
BlueDeviceType _parseDeviceType({
  required String deviceName,
  required int deviceType,
  required int majorDeviceClass,
  required int deviceClass,
}) {
  if (majorDeviceClass == 1024) {
    if ([1028].contains(deviceClass)) {
      return BlueDeviceType.headphone;
    }

    if ([516].contains(deviceClass)) {
      return BlueDeviceType.headphone;
    }
  }
  //IMAGING
  if (majorDeviceClass == 1536) {
    // if ([1664].contains(deviceClass)) {
    //   return BlueDeviceType.printer;
    // }
    return BlueDeviceType.printer;
  }
  if (majorDeviceClass == 256) {
    if (deviceType == 3 &&
        deviceClass == 272 &&
        deviceName.toLowerCase().contains("barrier")) {
      return BlueDeviceType.barrier;
    }

    return BlueDeviceType.computer;
  }

  return BlueDeviceType.unknown;
}

enum BlueDeviceType {
  printer(1, Icons.print),
  headphone(0, Icons.headset_mic),
  phone(0, Icons.smartphone),
  barrier(0.8, Icons.local_parking),
  computer(0, Icons.computer),
  unknown(0, Icons.bluetooth),
  ;

  const BlueDeviceType(this.priority, this.iconData);

  final double priority;
  final IconData iconData;

  bool get isPrinter => this == printer;
  bool get isHeadphone => this == headphone;
  bool get isPhone => this == phone;
  bool get isUnknown => this == unknown;
  bool get iscomputer => this == computer;
  bool get isbarrier => this == barrier;
}
