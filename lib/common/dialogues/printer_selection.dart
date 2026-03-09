import 'package:flutter/material.dart';
import 'package:pos_billing/common/models/bluetooth/bluetooth_device.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/common/singletons/bluedevice_handler.dart';
import 'package:pos_billing/common/singletons/printer_ctrl.dart';
import 'package:pos_billing/common/widgets/blue_device_card.dart';
import 'package:pos_billing/common/widgets/selection_tick.dart';
import 'package:pos_billing/config/enums/paper_size.dart';
import 'package:pos_billing/core/extensions/localdb_ext.dart';

Future<T?> showprinterSelectionSheet<T>({
  required BluetoothDeviceCustomInfo? selectedPrinter,
  required List<BluetoothDeviceCustomInfo> printers,
  required Function(BluetoothDeviceCustomInfo) onTap,
  required Function(BluetoothDeviceCustomInfo) onLongPress,
}) async {
  return await showModalBottomSheet(
    context: App.context,
    barrierColor: Colors.black38,
    useSafeArea: true,
    builder: (context) {
      return PrinterSelectionSheet(
        selectedPrinter: selectedPrinter,
        printers: printers,
        onTap: onTap,
        onLongPress: onLongPress,
      );
    },
  );
}

final _printcrl = BlueThurmalPrint.instance;

class PrinterSelectionSheet extends StatelessWidget {
  final BluetoothDeviceCustomInfo? selectedPrinter;
  final List<BluetoothDeviceCustomInfo> printers;
  final Function(BluetoothDeviceCustomInfo) onTap;
  final Function(BluetoothDeviceCustomInfo) onLongPress;
  const PrinterSelectionSheet({
    super.key,
    required this.selectedPrinter,
    required this.printers,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Select Printer"),
        actions: [
          ValueListenableBuilder(
            valueListenable: _printcrl.selectedpaperSizeNotifier,
            builder: (context, paperSize, child) {
              return Row(
                spacing: 5,
                children: [
                  for (var e in AppPaperSize.forThurmalPrint)
                    _PaperSize(
                      lable: e.lable,
                      isSelected: paperSize == e,
                      onTap: () {
                        _printcrl.selectedpaperSizeNotifier.value = e;
                        e.lable.boxPrinterPaperSize;
                      },
                    ),
                ],
              );
            },
          ),

          SizedBox(width: 8),
        ],
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
                        isSelected: e.address == selectedPrinter?.address,
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

class _PaperSize extends StatelessWidget {
  final String lable;
  final bool isSelected;
  final Function()? onTap;

  const _PaperSize({
    required this.lable,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSelected ? theme.primaryColor : Colors.grey.shade800;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 2, 0, 5),
            child: CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              radius: 25,
              child: Text.rich(
                TextSpan(
                  text: lable,
                  style: TextStyle(color: color, fontSize: 11),
                  children: const [
                    TextSpan(text: "\nmm", style: TextStyle(fontSize: 7)),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (isSelected)
            const Positioned(
              bottom: 3,
              right: 3,
              child: SelectionTick(checkRadius: 8),
            ),
        ],
      ),
    );
  }
}
