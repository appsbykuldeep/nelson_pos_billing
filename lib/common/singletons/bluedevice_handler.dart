import 'dart:async';
import 'dart:developer' as dev;

import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
import 'package:flutter/foundation.dart';
import 'package:pos_billing/common/abstract_classes/stateful_util.dart';
import 'package:pos_billing/common/dialogues/blue_device_selection.dart';
import 'package:pos_billing/common/dialogues/show_loading.dart';
import 'package:pos_billing/common/models/basic/permissions_model.dart';
import 'package:pos_billing/common/models/bluetooth/bluetooth_device.dart';
import 'package:pos_billing/common/models/bluetooth/bluetooth_events.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/common/singletons/device_package_info.dart';
import 'package:pos_billing/common/singletons/external_printer_handler.dart';
import 'package:pos_billing/config/enums/external_device_type.dart';
import 'package:pos_billing/config/enums/paper_size.dart';
import 'package:pos_billing/config/enums/printer_status.dart';
import 'package:pos_billing/core/extensions/list_ext.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';

class BluedeviceHandler implements StatefulUtil {
  BluedeviceHandler._();

  static final BluedeviceHandler _instance = BluedeviceHandler._();
  static BluedeviceHandler get instance => _instance;

  ValueNotifier<BluetoothEvents?> bluetoothEvents = ValueNotifier(null);
  ValueNotifier<List<BluetoothDeviceCustomInfo>> connectedDevices =
      ValueNotifier([]);
  List<BluetoothDeviceCustomInfo> availableprinter = [];

  Completer<PrinterStatus>? _connectionCompleter;
  StreamSubscription? _streamSubscription;

  BluetoothDeviceCustomInfo? connectedPrinter;
  BluetoothDeviceCustomInfo? connectedBarrier;

  String get deviceUid => DevicePackageDetails.instance.details.value.deviceUID;

  bool get isPrinterConnected =>
      connectedPrinter?.isConnected ??
      (bluetoothEvents.value?.printerStatus.isconnected ?? false);

  BluetoothDeviceCustomInfo? getConnectedDeviceByAddress(
    String address,
    String name,
  ) {
    BluetoothDeviceCustomInfo? device;
    device ??= connectedDevices.value.firstWhereOrNull(
      (e) => address.isNotEmpty && e.address.isNotEmpty && e.address == address,
    );
    device ??= connectedDevices.value.firstWhereOrNull(
      (e) => name.isNotEmpty && e.name.isNotEmpty && e.name == name,
    );
    return device;
  }

  Future<void> setBlutoothdevicesList({int milisec = 1000}) async {
    try {
      if (App.isMobileDevice) {
        // if (!await Permission.bluetooth.isGranted) {
        //   await Permission.bluetooth.request();
        // }
        // if (!await Permission.bluetoothConnect.isGranted) {
        //   await Permission.bluetoothConnect.request();
        // }
        // if (!await Permission.bluetoothScan.isGranted) {
        //   await Permission.bluetoothScan.request();
        // }

        if (!await AppPermissions.takeBluetoothPermissios()) {
          return;
        }

        availableprinter = BluetoothDeviceCustomInfo.fetchListByBlueDeviceInfo(
          await BluetoothThermalPrinter.getBluetooths,
          deviceUID: deviceUid,
          externalDeviceType: ExternalDeviceType.bluetoothMobilePrinter,
        );
      } else {
        List<BluetoothDeviceCustomInfo> local = [];

        local.addAll(await ExternalPrinterHandler.instance.getPrinterDevices());

        availableprinter = local;
      }

      for (var x in availableprinter) {
        if (x.isCloudDevice) {
          continue;
        }
        final connctedOne = getConnectedDeviceByAddress(x.address, x.name);
        if (x.address == connctedOne?.address) {
          x.isConnected = connctedOne?.isConnected ?? false;
          x.isSharedToCloud = connctedOne?.isSharedToCloud ?? false;
        }
      }
    } catch (e) {
      "Unable to search devices".showToast;
    }
  }

  Future<void> selectBlueDevice({
    bool refresh = false,

    required Function(BluetoothDeviceCustomInfo) onTap,
    required Function(BluetoothDeviceCustomInfo) onLongPress,
  }) async {
    if (refresh) {
      LoadingDialogue.show(lable: "Searching...");
      await setBlutoothdevicesList();
      LoadingDialogue.hide();
    }

    if (availableprinter.isNotEmpty) {
      await showBlueDeviceSelectionSheet(
        connectedDevices: connectedDevices.value,
        printers: availableprinter,
        onLongPress: onLongPress,
        onTap: onTap,
      );
    } else {
      "No printer available.".showToast;
    }
  }

  Future<(bool, String, BluetoothDeviceCustomInfo?)> connectToDevice(
    BluetoothDeviceCustomInfo device,
  ) async {
    bool status = false;
    String message = "";
    final extDevice = device.externalDeviceType;
    "connectToDevice :  :: $device".developerLog();
    if (extDevice.isusbWindowsPrinter) {
      final pr = await ExternalPrinterHandler.instance.connectToPrinter(device);
      (status, message) = pr.toRecord;
    } else {
      (status, message) = await _connectToPrinterViaAddress(device.address);
    }

    "connectToDevice : $status,$message :: $device".developerLog();
    if (!status) {
      return (status, message, null);
    }
    device.isConnected = true;
    if (status) {
      addConnectedDevice(device);
    }

    return (status, message, device);
  }

  void addConnectedDevice(BluetoothDeviceCustomInfo device) {
    final local = [...connectedDevices.value];
    if (!local.any((e) => e.address == device.address)) {
      local.add(device);
      connectedDevices.value = local;
    }
  }

  void removeConnectedDevice(BluetoothDeviceCustomInfo device) {
    connectedDevices.value = [
      ...connectedDevices.value,
    ].where((e) => e.address != device.address).toList();
  }

  Future<bool> printByBytes(List<int> data, AppPaperSize paperSize) async {
    final extDeviceType =
        connectedPrinter?.externalDeviceType ?? ExternalDeviceType.none;
    dynamic result;

    try {
      if (App.isMobileDevice && connectedPrinter != null) {
        result = await BluetoothThermalPrinter.writeBytes(data);
      } else if (extDeviceType.isUsbDevice || kIsWeb) {
        result = await ExternalPrinterHandler.instance
            .printByBytes(
              data: data,
              device: connectedPrinter,
              paperSize: paperSize,
            )
            .timeout(const Duration(seconds: 5));
      }
    } on TimeoutException {
      return false;
    } catch (e) {
      return false;
    }

    final status = ["true", true].contains(result);

    return status;
  }

  Future<bool> printByMultipartBytes(
    List<List<int>> data,
    AppPaperSize paperSize,
  ) async {
    final extDeviceType =
        connectedPrinter?.externalDeviceType ?? ExternalDeviceType.none;
    List<dynamic> results = [];

    try {
      if (App.isMobileDevice && connectedPrinter != null) {
        for (var e in data) {
          if (e.isEmpty) {
            continue;
          }
          results.add(await BluetoothThermalPrinter.writeBytes(e));
        }
      } else if (extDeviceType.isUsbDevice || kIsWeb) {
        final result = await ExternalPrinterHandler.instance
            .printByBytes(
              data: data.reduce((value, element) => [...value, ...element]),
              device: connectedPrinter,
              paperSize: paperSize,
            )
            .timeout(const Duration(seconds: 5));

        results.add(result);
      }
    } on TimeoutException {
      return false;
    } catch (e) {
      return false;
    }

    final status = results.any((e) => ["true", true].contains(e));

    return status;
  }

  Future<(bool, String)> _connectToPrinterViaAddress(String macAddress) async {
    try {
      if (macAddress.isEmpty) return (false, "");

      if (!AppPermissions.bluetooth) {
        return (false, "Please allow bluetooth permissions.");
      }

      final connectresult = await BluetoothThermalPrinter.connect(macAddress);
      if (connectresult != null && connectresult == "false") {
        _connectionCompleter = Completer<PrinterStatus>();
        final status = await _connectionCompleter!.future;
        _connectionCompleter = null;
        return (status.isconnected, "Connected to device.");
      }

      return (connectresult == "true")
          ? (true, "Connnected to device.")
          : (false, "Failed to conect device.");
    } catch (e) {
      debugPrint(e.toString());
    }
    return (false, "Failed to conect device.");
  }

  Future<bool> disconnectDevice(BluetoothDeviceCustomInfo? device) async {
    if (device == null) return true;
    final status = await _disconnectPrinter();
    removeConnectedDevice(device);
    return status;
  }

  Future<bool> _disconnectPrinter() async {
    try {
      final connectresult = await BluetoothThermalPrinter.disconnect();

      return connectresult == "true";
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  void _handleConnectionComplter(BluetoothEvents data) {
    dev.log(data.toString());
    if (data.processName != null &&
        _connectionCompleter != null &&
        !_connectionCompleter!.isCompleted &&
        data.processName == "connectPrinter_End") {
      _connectionCompleter!.complete(data.printerStatus);
    }
  }

  void _listenPrinterEvent() {
    _streamSubscription ??= BluetoothThermalPrinter.listen().listen((raw) {
      final data = BluetoothEvents.from(Map<String, dynamic>.from(raw));
      _handleConnectionComplter(data);
      bluetoothEvents.value = data;
    });
  }

  @override
  void onPageClose() {
    _streamSubscription?.cancel();
  }

  @override
  void onPageInit() {
    _listenPrinterEvent();
  }
}
