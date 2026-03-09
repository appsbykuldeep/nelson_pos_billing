import 'dart:convert';

import 'package:bluetooth_thermal_printer/blue_device_info.dart';
import 'package:pos_billing/config/enums/external_device_type.dart';
import 'package:pos_billing/core/extensions/localdb_ext.dart';
import 'package:pos_billing/core/extensions/parse_value_by_map.dart';

class BluetoothDeviceCustomInfo extends BlueDeviceInfo {
  BluetoothDeviceCustomInfo({
    super.name = "",
    super.address = "",
    super.deviceTypeId = 0,
    super.majorDeviceClassId = 0,
    super.deviceClassId = 0,
    super.deviceType = BlueDeviceType.unknown,
    super.isConnected = false,
    this.isCloudDevice = false,
    this.isSharedToCloud = false,
    this.deviceUID = "",
    required this.externalDeviceType,
    this.otherInfo,
  });

  final bool isCloudDevice;
  final String deviceUID;
  final ExternalDeviceType externalDeviceType;
  final Map<String, dynamic>? otherInfo;

  bool isSharedToCloud;

  static List<BluetoothDeviceCustomInfo> fetchList(dynamic data) {
    if (data is List) {
      return List<BluetoothDeviceCustomInfo>.from(
        data.map((e) => BluetoothDeviceCustomInfo.fromJson(e)),
      );
    }
    return [];
  }

  static List<BluetoothDeviceCustomInfo> fetchListByBlueDeviceInfo(
    List<BlueDeviceInfo> data, {
    String? deviceUID,
    required ExternalDeviceType externalDeviceType,
  }) {
    return List<BluetoothDeviceCustomInfo>.from(
      data.map(
        (ble) => BluetoothDeviceCustomInfo.fromBlueDeviceInfo(
          ble,
          deviceUID: deviceUID,
          externalDeviceType: externalDeviceType,
        ),
      ),
    );
  }

  factory BluetoothDeviceCustomInfo.fromBlueDeviceInfo(
    BlueDeviceInfo ble, {
    String? deviceUID,
    bool? isCloudDevice,
    required ExternalDeviceType externalDeviceType,
  }) {
    return BluetoothDeviceCustomInfo(
      name: ble.name,
      address: ble.address,
      deviceTypeId: ble.deviceTypeId,
      majorDeviceClassId: ble.majorDeviceClassId,
      deviceClassId: ble.deviceClassId,
      deviceType: ble.deviceType,
      isConnected: ble.isConnected,
      deviceUID: deviceUID ?? "",
      isCloudDevice: isCloudDevice ?? false,
      externalDeviceType: externalDeviceType,
    );
  }

  factory BluetoothDeviceCustomInfo.fromJson(Map<String, dynamic> json) {
    final ble = BlueDeviceInfo.fromJson(json);
    return BluetoothDeviceCustomInfo(
      name: ble.name,
      address: ble.address,
      deviceTypeId: ble.deviceTypeId,
      majorDeviceClassId: ble.majorDeviceClassId,
      deviceClassId: ble.deviceClassId,
      deviceType: ble.deviceType,
      isConnected: json.getboolOrNull("isConnected") ?? ble.isConnected,

      isCloudDevice: json.getbool("isCloudDevice"),
      isSharedToCloud: json.getbool("isSharedToCloud"),
      deviceUID: json.getString("deviceUID"),
      externalDeviceType: ExternalDeviceType.byId(
        json.getint("extDeviceTypeId"),
      ),
      otherInfo: json.getMapOrNull<String, dynamic>("otherInfo"),
    );
  }

  Map<String, dynamic> toMap() => {
    "deviceName": name,
    "address": address,
    "deviceUID": deviceUID,
    "deviceType": deviceTypeId,
    "majorDeviceClass": majorDeviceClassId,
    "deviceClass": deviceClassId,
    "isSharedToCloud": isSharedToCloud,
    "isCloudDevice": isCloudDevice,
    "extDeviceTypeId": externalDeviceType.id,
    "otherInfo": otherInfo,
  };

  Map<String, dynamic> toCloudMap({required String soketId}) => {
    "soketId": soketId,
    "deviceName": name,
    "deviceUID": deviceUID,
    "address": address,
    "deviceType": deviceTypeId,
    "majorDeviceClass": majorDeviceClassId,
    "deviceClass": deviceClassId,
    "isConnected": isConnected,
    "extDeviceTypeId": externalDeviceType.id,
    "otherInfo": otherInfo,
    "isCloudDevice": true,
  };

  // Local Printer
  void savePrintertoBox() {
    jsonEncode(toMap()).boxBluetoothDeviceCustomInfo;
  }

  static BluetoothDeviceCustomInfo? getPrinterFromBox() {
    final info = "".boxBluetoothDeviceCustomInfo;
    if (info.isEmpty) {
      return null;
    }

    return BluetoothDeviceCustomInfo.fromJson(jsonDecode(info));
  }

  static void clearBoxPrinter() {
    "--".boxBluetoothDeviceCustomInfo;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BluetoothDeviceCustomInfo &&
        other.address == address &&
        other.name == name;
  }

  @override
  int get hashCode {
    return address.hashCode ^ name.hashCode;
  }

  @override
  String toString() =>
      'BluetoothDeviceCustomInfo(name: $name,address: $address,deviceType: $deviceType,isConnected: $isConnected,isCloudDevice: $isCloudDevice,isSharedToCloud: $isSharedToCloud, deviceUID: $deviceUID, externalDeviceType: $externalDeviceType, otherInfo: $otherInfo)';

  BluetoothDeviceCustomInfo copyWith({
    String? name,
    String? address,
    int? deviceTypeId,
    int? majorDeviceClassId,
    int? deviceClassId,
    BlueDeviceType? deviceType,
    bool? isConnected,
    bool? isCloudDevice,
    bool? isSharedToCloud,
    String? deviceUID,
    ExternalDeviceType? externalDeviceType,
    Map<String, dynamic>? otherInfo,
  }) {
    return BluetoothDeviceCustomInfo(
      name: name ?? this.name,
      address: address ?? this.address,
      deviceTypeId: deviceTypeId ?? this.deviceTypeId,
      majorDeviceClassId: majorDeviceClassId ?? this.majorDeviceClassId,
      deviceClassId: deviceClassId ?? this.deviceClassId,
      deviceType: deviceType ?? this.deviceType,
      isConnected: isConnected ?? this.isConnected,
      isSharedToCloud: isSharedToCloud ?? this.isSharedToCloud,
      isCloudDevice: isCloudDevice ?? this.isCloudDevice,
      deviceUID: deviceUID ?? this.deviceUID,
      externalDeviceType: externalDeviceType ?? this.externalDeviceType,
      otherInfo: otherInfo ?? this.otherInfo,
    );
  }
}
