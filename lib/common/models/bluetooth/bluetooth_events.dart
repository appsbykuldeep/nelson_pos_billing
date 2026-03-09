import 'package:pos_billing/config/enums/printer_status.dart';
import 'package:pos_billing/core/extensions/parse_value_by_map.dart';

class BluetoothEvents {
  final String bluetoothAddress;
  final String? processName;
  final PrinterStatus printerStatus;

  final String state;
  final bool inputStream;
  final bool bluetoothSocket;
  final bool outputStream;

  BluetoothEvents({
    required this.bluetoothAddress,
    required this.processName,
    required this.printerStatus,
    required this.state,
    required this.inputStream,
    required this.bluetoothSocket,
    required this.outputStream,
  });

  factory BluetoothEvents.dicsonnected() => BluetoothEvents(
    bluetoothAddress: "",
    processName: null,
    printerStatus: PrinterStatus.disconnected,
    state: "false",
    inputStream: false,
    bluetoothSocket: false,
    outputStream: false,
  );

  factory BluetoothEvents.from(Map<String, dynamic> parser) {
    // print(json);

    PrinterStatus printerStatus = PrinterStatus.disconnected;

    final isConnecting = parser.getbool('isConnecting');
    final isConnected = parser.getbool('isConnected');

    if (isConnecting && !isConnected) {
      printerStatus = PrinterStatus.connecting;
    } else if (isConnected) {
      printerStatus = PrinterStatus.connected;
    }

    return BluetoothEvents(
      bluetoothAddress: parser.getString('bluetoothAddress'),
      processName: parser.getString('processName'),
      printerStatus: printerStatus,
      state: parser.getString('state'),
      inputStream: parser.getbool('inputStream'),
      bluetoothSocket: parser.getbool('bluetoothSocket'),
      outputStream: parser.getbool('outputStream'),
    );
  }

  @override
  String toString() {
    return 'BluetoothEvents(bluetoothAddress: $bluetoothAddress, processName: $processName, printerStatus: $printerStatus, state: $state, inputStream: $inputStream, bluetoothSocket: $bluetoothSocket, outputStream: $outputStream)';
  }
}
