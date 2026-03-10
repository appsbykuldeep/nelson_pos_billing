import 'dart:async';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:pos_billing/common/abstract_classes/stateful_util.dart';
import 'package:pos_billing/common/dialogues/confirmation.dart';
import 'package:pos_billing/common/dialogues/printer_selection.dart';
import 'package:pos_billing/common/dialogues/show_generaloption_sheet.dart';
import 'package:pos_billing/common/dialogues/show_loading.dart';
import 'package:pos_billing/common/models/basic/print_status.dart';
import 'package:pos_billing/common/models/basic/site_detail_model.dart';
import 'package:pos_billing/common/models/basic/user_details_model.dart';
import 'package:pos_billing/common/models/bluetooth/bluetooth_device.dart';
import 'package:pos_billing/common/models/sale/receipt_info.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/common/singletons/bluedevice_handler.dart';
import 'package:pos_billing/common/singletons/device_package_info.dart';
import 'package:pos_billing/common/singletons/login_ctrl.dart';
import 'package:pos_billing/config/enums/app_general_options.dart';
import 'package:pos_billing/config/enums/paper_size.dart';
import 'package:pos_billing/core/extensions/localdb_ext.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';
import 'package:pos_billing/core/functions/printable_tickets/general_counter_token/get_instant_bytes.dart';
import 'package:pos_billing/core/functions/printable_tickets/get_printable_ticket_image.dart';
import 'package:pos_billing/core/functions/printable_tickets/test_print/test_print_bytes_v1.dart';

class BlueThurmalPrint extends StatefulUtil {
  BlueThurmalPrint._();

  static final BlueThurmalPrint _instance = BlueThurmalPrint._();
  static BlueThurmalPrint get instance => _instance;

  final login = LoginUtil.instance;
  late final UserDetails userInfo = login.userNotifier.value;
  late final SiteDetail siteInfo = login.standDetailsNotifier.value;

  ValueNotifier<AppPaperSize> selectedpaperSizeNotifier = ValueNotifier(
    AppPaperSize.ticket58mm,
  );
  // var availableBluetoothDevices = <String>[];
  CapabilityProfile? _profile;

  final BluedeviceHandler _bluedeviceHandler = BluedeviceHandler.instance;

  BluetoothDeviceCustomInfo? get connectedPrinter =>
      _bluedeviceHandler.connectedPrinter;

  bool get isPrinterConnected =>
      _bluedeviceHandler.isPrinterConnected || kIsWeb;

  bool get isUsbDevice =>
      connectedPrinter?.externalDeviceType.isUsbDevice ?? kIsWeb;

  String get deviceUid => DevicePackageDetails.instance.details.value.deviceUID;

  PaperSize get selectedpaperSize =>
      selectedpaperSizeNotifier.value.toPOSSize();

  Future<void> selectPrinter({bool refresh = false}) async {
    if (refresh) {
      LoadingDialogue.show(lable: "Searching...");
      await _bluedeviceHandler.setBlutoothdevicesList();
      LoadingDialogue.hide();
    }

    if (_bluedeviceHandler.availableprinter.isNotEmpty) {
      final isInProgress =
          _bluedeviceHandler
              .bluetoothEvents
              .value
              ?.printerStatus
              .isInProgress ??
          false;
      final macAddress = connectedPrinter?.address ?? "";

      if (!isInProgress &&
          _bluedeviceHandler.availableprinter.any(
            (e) => macAddress.isNotEmpty && e.address == macAddress,
          )) {
        connectToPrinter();
      }

      await showprinterSelectionSheet(
        selectedPrinter: connectedPrinter,
        printers: _bluedeviceHandler.availableprinter,
        onLongPress: onLongPressBluetoothDevice,
        onTap: onTapBluetoothDevice,
      );
    } else {
      "No printer available.".showToast;
    }
  }

  Future<void> onLongPressBluetoothDevice(BluetoothDeviceCustomInfo val) async {
    if (!val.isConnected) {
      return;
    }
    final action = await showGeneralOptionSheet(
      context: App.context,
      options: [
        AppGeneralOption.disconnect,
        //TODO : remove static condition when completed.
        if (!val.isCloudDevice && 1 == 0) AppGeneralOption.cloudDone,
      ],
    );

    if (action.isdisconnect) {
      LoadingDialogue.show(lable: "Disconnecting...");
      await disconnectPrinter();
      BluetoothDeviceCustomInfo.clearBoxPrinter();
      LoadingDialogue.hide();
      App.back();
    }
  }

  Future<void> onTapBluetoothDevice(BluetoothDeviceCustomInfo val) async {
    if (val.isSharedToCloud ||
        (val.isCloudDevice && val.deviceUID == deviceUid)) {
      return;
    }

    if (val.isCloudDevice) {
      _bluedeviceHandler.connectedPrinter = val;
      App.back();
      return;
    }

    final confirm = await makeconfirmation();
    if (!confirm) return;

    LoadingDialogue.show(lable: "Connecting...");
    final (status, message, device) = await _bluedeviceHandler.connectToDevice(
      val,
      // BluetoothDeviceCustomInfo.fromBlueDeviceInfo(val),
    );

    LoadingDialogue.hide();
    if (!status) {
      message.showAlert;
      return;
    }
    _bluedeviceHandler.connectedPrinter = device;
    device?.savePrintertoBox();

    App.back();
  }

  Future<(bool, String, BluetoothDeviceCustomInfo?)> connectToPrinter() async {
    _bluedeviceHandler.connectedPrinter ??=
        BluetoothDeviceCustomInfo.getPrinterFromBox();
    if (connectedPrinter == null) {
      return (false, "", null);
    }
    // await _bluedeviceHandler.setBlutoothdevicesList();

    return _bluedeviceHandler.connectToDevice(connectedPrinter!);
  }

  Future<bool> disconnectPrinter() async {
    connectedPrinter?.isConnected = false;
    connectedPrinter?.isSharedToCloud = false;

    final status = _bluedeviceHandler.disconnectDevice(connectedPrinter);
    _bluedeviceHandler.connectedPrinter = null;
    return status;
  }

  Future<Generator> getTicketGenerator() async {
    _profile ??= await CapabilityProfile.load();
    return Generator(selectedpaperSize, _profile!, spaceBetweenRows: 0);
  }

  Future<PrintStatus> printReceiptViaPreview({
    required Uint8List receiptInfo,
  }) async {
    final bytes = await getPrintableTicketImageByImage(
      ticket: await getTicketGenerator(),
      imageBase64: receiptInfo,
    );
    final status = await printBytesData(data: bytes);

    return status;
  }

  Future<PrintStatus> printgeneralCounterToken({
    required ReceiptInfo receiptInfo,
  }) async {
    final prints = siteInfo.siteConfigurations.numberOfprints;
    final delay = Duration(
      seconds: siteInfo.siteConfigurations.printDelayInSec,
    );

    final bytes = await getInstantReceiptPrintableBytes(
      ticket: await getTicketGenerator(),
      stand: login.standDetailsNotifier.value,
      receiptInfo: receiptInfo,
    );

    late PrintStatus status;

    for (int i = 1; i <= prints; i++) {
      status = await printBytesData(data: bytes);
      if (!status.status) {
        break;
      }
      await Future.delayed(delay);
    }

    return status;
  }

  Future<PrintStatus> testPrint() async {
    final prints = siteInfo.siteConfigurations.numberOfprints;
    final delay = Duration(
      seconds: siteInfo.siteConfigurations.printDelayInSec,
    );

    final bytes = await getTestPrintBytes(ticket: await getTicketGenerator());

    late PrintStatus status;

    for (int i = 1; i <= prints; i++) {
      status = await printBytesData(data: bytes);
      if (!status.status) {
        break;
      }
      await Future.delayed(delay);
    }

    return status;
  }

  Future<bool> printTicket(
    List<int> data, {
    AppPaperSize paperSize = AppPaperSize.ticket58mm,
  }) async {
    return await _bluedeviceHandler.printByBytes(data, paperSize);
  }

  Future<bool> printByMultipartBytes(
    List<List<int>> data, {
    AppPaperSize paperSize = AppPaperSize.ticket58mm,
  }) async {
    return await _bluedeviceHandler.printByMultipartBytes(data, paperSize);
  }

  Future<PrintStatus> printBytesData({required List<int> data}) async {
    PrintStatus ptstatus = PrintStatus();

    if (!isPrinterConnected) {
      ptstatus.msj = "Printer not connected.";
      return ptstatus;
    }

    try {
      if (await printTicket(data)) {
        ptstatus.status = true;
        ptstatus.msj = "Print successfully.";
      } else {
        ptstatus.msj = "Failed to print";
      }
    } catch (e) {
      ptstatus.msj = e.toString();
    }

    return ptstatus;
  }

  @override
  void onPageClose() {}

  @override
  void onPageInit() async {
    selectedpaperSizeNotifier.value = AppPaperSize.parse(
      "".boxPrinterPaperSize,
    );
    connectToPrinter();
  }
}
