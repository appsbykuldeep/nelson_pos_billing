import 'package:flutter/material.dart';
import 'package:pos_billing/common/models/bluetooth/bluetooth_device.dart';
import 'package:pos_billing/common/models/bluetooth/bluetooth_events.dart';
import 'package:pos_billing/config/enums/printer_status.dart';

class BluetoothDeviceCard extends StatelessWidget {
  final bool isSelected;
  final BluetoothDeviceCustomInfo onedata;
  final BluetoothEvents? event;
  const BluetoothDeviceCard({
    super.key,
    required this.onedata,
    this.event,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isConnected = onedata.isConnected;
    // "onedata $onedata".developerLog();
    // final isConnected = (event?.printerStatus.isconnected ?? false);
    return Container(
      constraints: const BoxConstraints(minHeight: 50),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.blueGrey.shade300, width: 0.45),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Row(
        children: [
          Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            size: 20,
            color: theme.primaryColor,
          ),
          SizedBox(width: 5),

          Icon(
            (onedata.deviceType.iconData),
            size: 30,
            color: theme.primaryColor,
          ),
          SizedBox(width: 5),
          Expanded(
            child: Text(
              onedata.name,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),

          if (onedata.isCloudDevice)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                isConnected ? Icons.cloud_done : Icons.cloud_off,
                size: 20,
                color: isSelected
                    ? (isConnected ? Colors.green : Colors.red)
                    : null,
              ),
            ),

          if (onedata.isSharedToCloud)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.lan,
                size: 20,
                color: isConnected ? Colors.green : Colors.red,
              ),
            ),

          if (!onedata.isCloudDevice && isSelected)
            Visibility(
              visible: (onedata.isConnected),
              child: Icon(
                switch (event?.printerStatus) {
                  PrinterStatus.connecting => Icons.hourglass_empty,
                  PrinterStatus.disconnected => Icons.close,
                  PrinterStatus.connected => Icons.done_all,
                  _ => Icons.done,
                },
                // isConnected ? Icons.done_all : Icons.done,
                size: 20,
                color: isConnected ? Colors.green : Colors.red,
              ),
            ),
        ],
      ),
    );
  }
}
