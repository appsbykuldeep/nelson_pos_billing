import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart' hide BluetoothEvents;
import 'package:pos_billing/common/abstract_classes/stateful_util.dart';
import 'package:pos_billing/common/models/basic/permissions_model.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/common/singletons/printer_ctrl.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';

class BluetoothConnectivity extends StatefulUtil {
  BluetoothConnectivity._();

  static final BluetoothConnectivity _instance = BluetoothConnectivity._();

  static BluetoothConnectivity get instance => _instance;

  StreamSubscription<BluetoothAdapterState>? subscription;

  static bool _status = false;

  // static bool get available => _status;
  // static bool get notAvailable => !_status;

  void _updatePrinterStatus() {
    if (_status) {
      BlueThurmalPrint.instance.connectToPrinter();
    } else {
      BlueThurmalPrint.instance.disconnectPrinter();
    }
  }

  @override
  void onPageClose() {
    subscription?.cancel();
    subscription = null;
  }

  @override
  void onPageInit() async {
    if (App.isNotMobileDevice || !await FlutterBluePlus.isSupported) {
      "FlutterBluePlus not supported !".developerLog();
      return;
    }

    "FlutterBluePlus supported !".developerLog();

    if (App.isMobileDevice && !AppPermissions.bluetooth) return;
    subscription ??= FlutterBluePlus.adapterState.listen((
      BluetoothAdapterState state,
    ) {
      _status = state == BluetoothAdapterState.on;
      _updatePrinterStatus();
    });
  }
}
