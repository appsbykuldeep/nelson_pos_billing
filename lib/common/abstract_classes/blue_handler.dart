// ignore_for_file: source_gen
// ignore_for_file: type=lint

import 'package:pos_billing/common/models/basic/process_result.dart';
import 'package:pos_billing/common/models/bluetooth/bluetooth_device.dart';
import 'package:pos_billing/config/enums/paper_size.dart';

abstract class PrinterDeviceMethod {
  Future<List<BluetoothDeviceCustomInfo>> getPrinterDevices();

  Future<StatusResult> connectToPrinter(BluetoothDeviceCustomInfo device);

  Future<bool> printByBytes({
    required List<int> data,
    required BluetoothDeviceCustomInfo device,
    required AppPaperSize paperSize,
  });

  Future<void> disconnectPrinterDevice(BluetoothDeviceCustomInfo device);
}
