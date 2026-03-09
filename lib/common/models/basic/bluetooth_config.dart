// import 'dart:async';

// import 'package:bluetooth_thermal_printer/bluetooth_thermal_printer.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:vparking_app/class/page_utils.dart';
// import 'package:vparking_app/models/bluetooth/bluetooth_device.dart';

// class BluetoothConfig extends StatefulUtils {
//   BluetoothConfig._();

//   static final BluetoothConfig _instance = BluetoothConfig._();

//   static BluetoothConfig get instance => _instance;

//   bool bluetoothAvailable = false;
//   bool connected = false;
//   bool bluetoothOn = false;
//   List<BluetoothDeviceInfo> bluetoothDevices = [];
//   StreamSubscription<BluetoothAdapterState>? blueSubscription;
//   StreamSubscription? scanSubscription;

//   bool get baseCheck => (bluetoothAvailable && bluetoothOn);
//   bool get canPrint => (bluetoothAvailable && bluetoothOn && connected);
//   String get baseErrorMsj {
//     if (!bluetoothAvailable) return "Bluetooth not fond.";
//     if (!bluetoothOn) return "Please trun on bluetooth.";
//     return "";
//   }

//   String get printErrorMsj {
//     if (!bluetoothAvailable) return "Bluetooth not fond.";
//     if (!bluetoothOn) return "Please trun on bluetooth.";
//     if (!connected) return "Printer not connected.";
//     return "";
//   }

//   void _listneBluetooth() {
//     blueSubscription ??=
//         FlutterBluePlus.adapterState.listen((BluetoothAdapterState event) {
//       final isOn = event == BluetoothAdapterState.on;
//       bluetoothAvailable = event != BluetoothAdapterState.unavailable;
//       connected = isOn;
//       bluetoothOn = isOn;
//     });

//     scanSubscription = FlutterBluePlus.onScanResults.listen((result) {
//       for (var x in result) {
//         print(["onScanResults", x.advertisementData, x.device.remoteId]);
//       }
//     });
//   }

//   Future<void> startManagerScan({
//     int milisec = 3000,
//   }) async {
//     await FlutterBluePlus.startScan();
//     // await FlutterBluePlus.startScan(timeout: Duration(milliseconds: milisec));
//     // await Future.delayed(Duration(milliseconds: milisec));
//   }

  

//   @override
//   void onPageClose() {
//     blueSubscription?.cancel();
//     scanSubscription?.cancel();
//   }

//   @override
//   void onPageInit() {
//     _listneBluetooth();
//   }
// }
