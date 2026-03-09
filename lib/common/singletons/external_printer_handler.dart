import 'dart:typed_data';

import 'package:bluetooth_thermal_printer/blue_device_info.dart';
import 'package:pos_billing/common/abstract_classes/blue_handler.dart';
import 'package:pos_billing/common/models/basic/process_result.dart';
import 'package:pos_billing/common/models/bluetooth/bluetooth_device.dart';
import 'package:pos_billing/config/enums/external_device_type.dart';
import 'package:pos_billing/config/enums/paper_size.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';
import 'package:printing/printing.dart';

class ExternalPrinterHandler implements PrinterDeviceMethod {
  ExternalPrinterHandler._();

  static final ExternalPrinterHandler _instance = ExternalPrinterHandler._();

  static ExternalPrinterHandler get instance => _instance;

  @override
  Future<bool> printByBytes({
    required List<int> data,
    required BluetoothDeviceCustomInfo? device,
    required AppPaperSize paperSize,
  }) async {
    if (device != null) {
      return await Printing.directPrintPdf(
        printer: getPrinterDevice(device),
        onLayout: (format) => Uint8List.fromList(data),
        name: "Print",
        format: paperSize.toPdfPageFormat(),
        forceCustomPrintPaper: true,
      );
    } else {
      await Future.delayed(const Duration(milliseconds: 100));
      return await Printing.layoutPdf(
        onLayout: (format) => Uint8List.fromList(data),
        name: "Print",
        format: paperSize.toPdfPageFormat(),
        forceCustomPrintPaper: true,
      );
    }
  }

  @override
  Future<StatusResult> connectToPrinter(
    BluetoothDeviceCustomInfo customDevice,
  ) async {
    bool status = false;

    if (1 == 1) {
      customDevice.isConnected = true;
      return StatusResult(status: true, message: "Connected to printer !");
    }

    return StatusResult(status: status, message: "Failed to connect !");
  }

  @override
  Future<void> disconnectPrinterDevice(
    BluetoothDeviceCustomInfo device,
  ) async {}

  @override
  Future<List<BluetoothDeviceCustomInfo>> getPrinterDevices() async {
    // if (kIsWeb || !Platform.isWindows) {
    //   return [];
    // }

    List<BluetoothDeviceCustomInfo> printers = [];

    try {
      final p0 = await Printing.listPrinters();

      for (var device in p0) {
        if (device.name.isNotEmpty &&
            !_skipWindowPrinters.contains(device.name.toLowerCase())) {
          printers.add(
            getDeviceCustomInfo(
              printer: device,
              externalDeviceType: ExternalDeviceType.usbWindowsPrinter,
            ),
          );
        }
      }

      p0.toString().developerLog();
    } catch (e) {
      return printers;
    }

    return printers;
  }

  BluetoothDeviceCustomInfo getDeviceCustomInfo({
    required Printer printer,

    required ExternalDeviceType externalDeviceType,
  }) {
    return BluetoothDeviceCustomInfo(
      externalDeviceType: externalDeviceType,
      address: printer.url,
      name: printer.name,
      otherInfo: printer.toMap(),
      deviceType: BlueDeviceType.computer,
    );
  }

  Printer getPrinterDevice(BluetoothDeviceCustomInfo device) {
    return Printer.fromMap(device.otherInfo ?? {});
  }

  final List<String> _skipWindowPrinters = [
    "send to onenote 2010",
    "onenote for windows 10",
    "microsoft xps document writer",
    "microsoft print to pdf",
    "fax",
  ];
}
