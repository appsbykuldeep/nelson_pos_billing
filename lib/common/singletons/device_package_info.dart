import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DevicePackageDetails {
  DevicePackageDetails._();

  static final DevicePackageDetails _instance = DevicePackageDetails._();
  static DevicePackageDetails get instance => _instance;

  ValueNotifier<PackageDeviceInfo> details = ValueNotifier(PackageDeviceInfo());

  bool get isAboveAndroid14 => details.value.androidSDKInt > 33;
  String get bundleId => details.value.packageName;
  String get appName => details.value.appName;

  bool _isCalled = false;

  Future<void> setDeviceDetails() async {
    if (_isCalled) return;
    _isCalled = true;
    details.value = await _getPackageDeviceInfo();

    // if (isAboveAndroid14) {
    //   ensureEdgeToEdge();
    // }
  }

  Future<PackageDeviceInfo> _getPackageDeviceInfo() async {
    PackageDeviceInfo pdInfo = PackageDeviceInfo();

    final package = await PackageInfo.fromPlatform();
    pdInfo.appName = package.appName;
    pdInfo.packageName = package.packageName;
    pdInfo.version = package.version;
    pdInfo.buildNumber = int.tryParse(package.buildNumber) ?? 0;
    pdInfo.buildSignature = package.buildSignature;
    pdInfo.installerStore = package.installerStore;

    if (kIsWeb) {
      final i = await DeviceInfoPlugin().webBrowserInfo;
      pdInfo.deviceType = "web";
      pdInfo.deviceInfo = [i.browserName.name, i.product].join(",");
      pdInfo.deviceUID = "web";
      pdInfo.buildNumber = 1;
    } else if (Platform.isWindows) {
      final i = await DeviceInfoPlugin().windowsInfo;
      pdInfo.deviceType = "windows";
      pdInfo.deviceInfo = ["windows", i.computerName].join(",");
      pdInfo.deviceUID = i.deviceId;
    } else if (Platform.isAndroid) {
      final i = await DeviceInfoPlugin().androidInfo;
      final isPOS = checkForPOS(i.systemFeatures);
      pdInfo.isPOS = isPOS;
      pdInfo.androidSDKInt = i.version.sdkInt;
      pdInfo.systemFeatures = i.systemFeatures;
      pdInfo.isPhysicalDevice = i.isPhysicalDevice;
      pdInfo.deviceTitle = [
        i.brand,
        i.model,
        i.manufacturer,
      ].where((e) => e.isNotEmpty).take(2).join(" ");

      pdInfo.deviceInfo = [
        if (i.brand.isNotEmpty) "brand:${i.brand}",
        if (i.manufacturer.isNotEmpty) "manufacturer:${i.manufacturer}",
        if (i.model.isNotEmpty) "model:${i.model}",
        if (i.version.release.isNotEmpty)
          "version_release:${i.version.release}",
        "isPhysicalDevice:${i.isPhysicalDevice}",
      ].join("|");

      final t0 = pdInfo.isPhysicalDevice ? "Android" : "AndroidE";
      pdInfo.deviceType = isPOS ? "$t0 POS" : t0;
      pdInfo.deviceUID = i.id;
    } else if (Platform.isIOS) {
      final iosInfo = await DeviceInfoPlugin().iosInfo;
      pdInfo.deviceType = "IOS";
      pdInfo.deviceInfo = [iosInfo.utsname.machine].join(",");
      pdInfo.deviceUID = iosInfo.identifierForVendor ?? "";
    }

    // try {
    //   final uid = await getDeviceUID(androidSDKInt: pdInfo.androidSDKInt);

    //   "DeiveUID2 : $uid".developerLog("DeiveUID");
    //   if (uid != null) {
    //     pdInfo.deviceUID = uid;
    //   }
    // } catch (e) {
    //   e.toString().developerLog();
    // }

    return pdInfo;
  }

  static bool checkForPOS(List<String> systemFeatures) {
    final status =
        (systemFeatures.contains('android.hardware.barcode') &&
        systemFeatures.contains('android.hardware.printer'));

    return status;
  }

  // Future<void> initialized() async {
  //   details.value = await _getPackageDeviceInfo();
  // }
}

// Data Model Class

class PackageDeviceInfo {
  String appName;
  String packageName;
  String version;
  int buildNumber;
  String buildSignature;
  String? installerStore;
  String deviceType;
  String deviceUID;
  String deviceTitle;
  String deviceInfo;
  bool isPhysicalDevice;
  bool isPOS;
  int androidSDKInt;
  List<String> systemFeatures;

  PackageDeviceInfo({
    this.appName = '',
    this.packageName = '',
    this.version = '',
    this.buildNumber = 0,
    this.buildSignature = '',
    this.installerStore,
    this.deviceType = "",
    this.deviceUID = "",
    this.deviceTitle = "",
    this.deviceInfo = "",
    this.isPhysicalDevice = true,
    this.isPOS = true,
    this.androidSDKInt = 0,
    this.systemFeatures = const [],
  });

  Map<String, dynamic> toMap() => {
    "appName": appName,
    "packageName": packageName,
    "version": version,
    "buildNumber": buildNumber,
    "buildSignature": buildSignature,
    "installerStore": installerStore,
    "deviceType": deviceType,
    "deviceInfo": deviceInfo,
    "deviceUID": deviceUID,
    "deviceTitle": deviceTitle,
    "isPOS": isPOS,
    "androidSDKInt": androidSDKInt,
    "systemFeatures": systemFeatures,
    "isPhysicalDevice": isPhysicalDevice,
  };

  factory PackageDeviceInfo.fromMap(Map<String, dynamic> json) {
    return PackageDeviceInfo(
      appName: json["appName"] as String,
      packageName: json["packageName"] as String,
      version: json["version"] as String,
      buildNumber: json["buildNumber"] as int,
      buildSignature: json["buildSignature"] as String,
      installerStore: json["installerStore"] as String,
      deviceType: json["deviceType"] as String,
      deviceInfo: json["deviceInfo"] as String,
      deviceUID: json["deviceUID"] as String,
      deviceTitle: json["deviceTitle"] as String,
      isPOS: json["isPOS"] as bool,
      androidSDKInt: json["androidSDKInt"] as int,
      systemFeatures: List<String>.from(json["systemFeatures"] as List),
      isPhysicalDevice: json["isPhysicalDevice"] as bool,
    );
  }

  @override
  String toString() {
    return 'PackageDeviceInfo(appName: $appName, packageName: $packageName, version: $version, buildNumber: $buildNumber, buildSignature: $buildSignature, installerStore: $installerStore, deviceType: $deviceType, deviceUID: $deviceUID, deviceTitle: $deviceTitle, deviceInfo: $deviceInfo, isPhysicalDevice: $isPhysicalDevice, isPOS: $isPOS, androidSDKInt: $androidSDKInt, systemFeatures: $systemFeatures)';
  }
}
