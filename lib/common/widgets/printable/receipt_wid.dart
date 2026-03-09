import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pos_billing/common/models/basic/site_detail_model.dart';
import 'package:pos_billing/common/models/sale/receipt_info.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/common/singletons/printer_ctrl.dart';
import 'package:pos_billing/common/singletons/widget_to_image_converter.dart';
import 'package:pos_billing/core/extensions/datetime_ext.dart';
import 'package:pos_billing/core/extensions/num_ex.dart';
import 'package:screenshot/screenshot.dart';

class ReceiptPrintableWid {
  final SiteDetail stand;
  final ReceiptInfo receiptInfo;
  const ReceiptPrintableWid({required this.stand, required this.receiptInfo});

  Future<Uint8List?> getPrintableBytes() async {
    if (1 == 0) {
      final conv = WidgetToImageConverter();

      return await conv.getWidgetBytes(build(), highQuality: false);
    }

    final ScreenshotController screenshotController = ScreenshotController();

    Uint8List capturedImage = await screenshotController.captureFromWidget(
      InheritedTheme.captureAll(
        App.context,
        Material(color: Colors.white, child: build()),
      ),
      delay: const Duration(milliseconds: 10),
      pixelRatio: 2,
    );

    return capturedImage;
  }

  double get smallFontSize => 15;
  double get mediumFontSize => 20;
  double get largeFontSize => 28;
  double get extralargeFontSize => 40;

  TextStyle get siteNameStyle => TextStyle(
    fontSize: largeFontSize,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.1,
  );
  TextStyle get smallStyle => TextStyle(
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );
  TextStyle get mediumStyle => TextStyle(
    fontSize: mediumFontSize,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  Widget build() {
    return Container(
      // width: 384, // Standard pixel width for 58mm printers. Use 576 for 80mm.
      width: BlueThurmalPrint.instance.selectedpaperSize.width.toDouble(),
      padding: const EdgeInsets.all(5),

      // decoration: BoxDecoration(border: Border.all(), color: Colors.white),
      child: Column(
        spacing: 0,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            stand.siteName,
            style: siteNameStyle,
            textAlign: TextAlign.center,
          ),
          Text(
            stand.siteAddressLine1,
            style: siteNameStyle,
            textAlign: TextAlign.center,
          ),
          Text(
            stand.siteAddressLine2,
            style: siteNameStyle,
            textAlign: TextAlign.center,
          ),
          Divider(thickness: 1.5),
          Row(
            spacing: 3,
            children: [
              Text("Bill: ${receiptInfo.showSaleNumber}", style: smallStyle),
              Expanded(
                child: Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: Text(
                    DateTime.now().custumDateFormat("dd-MM-yyy hh:mm:ss a"),
                    style: smallStyle,
                  ),
                ),
              ),
            ],
          ),
          Divider(thickness: 1.5),

          Table(
            columnWidths: {
              0: FlexColumnWidth(3.5),
              1: FlexColumnWidth(1.5),
              2: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                children: [
                  Text("Item", style: mediumStyle),
                  Center(child: Text("Qty", style: mediumStyle)),
                  Align(
                    alignment: AlignmentGeometry.centerRight,
                    child: Text("Amt", style: mediumStyle),
                  ),
                ],
              ),
            ],
          ),

          Divider(thickness: 1.5),
          Table(
            columnWidths: {
              0: FlexColumnWidth(3.5),
              1: FlexColumnWidth(1.5),
              2: FlexColumnWidth(2),
            },
            children: [
              for (var e in receiptInfo.receiptItems)
                TableRow(
                  children: [
                    Text(e.itemName, style: mediumStyle),
                    Center(
                      child: Text(
                        e.itemQuantity.thousandText(),
                        style: mediumStyle,
                      ),
                    ),
                    Align(
                      alignment: AlignmentGeometry.centerRight,
                      child: Text(
                        e.itemAmount.thousandText(),
                        style: mediumStyle,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          Divider(thickness: 1.5),
          Text(
            "Rs.${receiptInfo.totalAmount.thousandText()}",

            style: siteNameStyle.copyWith(fontSize: 30),
          ),
          Divider(thickness: 1.5),

          // Text("Thank You! Visit Again", style: mediumStyle),
        ],
      ),
    );
  }
}
