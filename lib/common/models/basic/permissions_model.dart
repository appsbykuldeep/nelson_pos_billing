import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pos_billing/common/singletons/app.dart';

class AppPermissions {
  AppPermissions._();

  // Declare all required permissions here.
  static final List<Permission> _requiredAppPermissions = [
    Permission.notification,
    Permission.bluetoothScan,
    Permission.bluetooth,
    Permission.bluetoothConnect,
    Permission.storage,
    Permission.camera,
    // Permission.photos,
    Permission.microphone,
    Permission.location,

    // Other permissions
  ];
  // Declare all required permissions here.
  static final List<Permission> _requiredWebPermissions = [
    // Permission.notification,
    // Permission.location,
    // Other permissions
  ];

  static final Map<Permission, PermissionStatus> _permissionsCache = {};

  /// Only checking all [_requiredAppPermissions] permission status.
  static Future<void> checkAllPermissionsStatus() async {
    for (var permission in _requiredAppPermissions) {
      _permissionsCache[permission] = await permission.status;
    }
  }

  /// Requesting all [_requiredAppPermissions] permission status.
  static Future<void> takeAllPermissions() async {
    try {
      // if (App.isNotMobileDevice) return;
      final requiredPermission = kIsWeb
          ? _requiredWebPermissions
          : _requiredAppPermissions;

      if (requiredPermission.isEmpty) return;
      final status = await requiredPermission.request();
      _permissionsCache.addAll(status);
    } catch (e) {
      return;
    }
  }

  /// Requesting all [_requiredAppPermissions] permission status.
  static Future<void> takeBluetoothPermission() async {
    try {
      if (App.isNotMobileDevice) return;

      final status = await [
        Permission.bluetoothScan,
        Permission.bluetooth,
        Permission.bluetoothConnect,
      ].request();
      _permissionsCache.addAll(status);
    } catch (e) {
      return;
    }
  }

  // Getting Granted status from cache.
  static bool get camera => isAccepted(Permission.camera);
  static bool get location => isAccepted(Permission.location);
  static bool get notification => isAccepted(Permission.notification);
  static bool get bluetooth =>
      isAccepted(Permission.bluetooth) || isAccepted(Permission.bluetoothScan);
  // static bool get bluetoothScan => isAccepted(Permission.bluetoothScan);
  //......

  // Optional methods for individual permission.
  static Future<PermissionStatus> takeCameraPermission() =>
      checkPermissionStatus(Permission.camera);
  static Future<PermissionStatus> takeLocationPermission() =>
      checkPermissionStatus(Permission.location);

  static Future<PermissionStatus> takeNotificationPermission() =>
      checkPermissionStatus(Permission.notification);
  static Future<PermissionStatus> takeBluetoothScanPermission() =>
      checkPermissionStatus(Permission.bluetoothScan);

  static Future<bool> takeBluetoothPermissios() async {
    if (!App.isMobileDevice) {
      return false;
    }
    final s0 = await checkPermissionStatus(Permission.bluetooth);
    final s1 = await checkPermissionStatus(Permission.bluetoothConnect);
    final s3 = await checkPermissionStatus(Permission.bluetoothScan);

    return s0.isGranted || s1.isGranted || s3.isGranted;
  }

  //......

  // helper function for boolean status
  static bool isAccepted(Permission permission) {
    final status = _permissionsCache[permission];
    if (status == null) return false;
    return (status.isGranted || status.isLimited);
  }

  // Requesting & caching individual permission.
  static Future<PermissionStatus> checkPermissionStatus(
    Permission permission,
  ) async {
    final currentStatus = await permission.status;
    _permissionsCache[permission] = currentStatus;
    if (currentStatus.isGranted || currentStatus.isLimited) {
      return currentStatus;
    }
    if (!currentStatus.isPermanentlyDenied) {
      final status = await permission.request();
      _permissionsCache[permission] = status;
      return status;
    }
    return currentStatus;
  }
}
