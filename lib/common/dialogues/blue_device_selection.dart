import 'package:flutter/material.dart';
import 'package:pos_billing/common/models/bluetooth/bluetooth_device.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/common/singletons/bluedevice_handler.dart';
import 'package:pos_billing/common/widgets/blue_device_card.dart';

Future<T?> showBlueDeviceSelectionSheet<T>({
  required List<BluetoothDeviceCustomInfo> connectedDevices,
  required List<BluetoothDeviceCustomInfo> printers,
  required Function(BluetoothDeviceCustomInfo) onTap,
  required Function(BluetoothDeviceCustomInfo) onLongPress,
}) async {
  return await showModalBottomSheet(
    context: App.context,
    barrierColor: Colors.black38,
    useSafeArea: true,
    builder: (context) {
      return _BlueDeviceSelectionSheet(
        connectedDevices: connectedDevices,
        printers: printers,
        onTap: onTap,
        onLongPress: onLongPress,
      );
    },
  );
}

class _BlueDeviceSelectionSheet extends StatelessWidget {
  final List<BluetoothDeviceCustomInfo> connectedDevices;
  final List<BluetoothDeviceCustomInfo> printers;
  final Function(BluetoothDeviceCustomInfo) onTap;
  final Function(BluetoothDeviceCustomInfo) onLongPress;
  const _BlueDeviceSelectionSheet({
    required this.connectedDevices,
    required this.printers,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Bluetooth Devices"),
      ),
      body: SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: BluedeviceHandler.instance.bluetoothEvents,
          builder: (context, event, _) {
            return Column(
              children: printers
                  .map(
                    (e) => InkWell(
                      onTap: () {
                        onTap(e);
                      },
                      onLongPress: () => onLongPress(e),
                      child: BluetoothDeviceCard(
                        isSelected: connectedDevices.any(
                          (p) => p.address == e.address,
                        ),
                        onedata: e,
                        event:
                            (event == null ||
                                event.bluetoothAddress != e.address)
                            ? null
                            : event,
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
