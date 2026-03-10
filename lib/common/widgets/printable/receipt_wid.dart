import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pos_billing/common/classes/time_laps.dart';
import 'package:pos_billing/common/models/basic/site_detail_model.dart';
import 'package:pos_billing/common/models/sale/receipt_info.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/common/singletons/printer_ctrl.dart';
import 'package:pos_billing/core/extensions/datetime_ext.dart';
import 'package:pos_billing/core/extensions/num_ex.dart';
import 'package:screenshot/screenshot.dart';

class ReceiptPrintableWid {
  final SiteDetail stand;
  final ReceiptInfo receiptInfo;
  const ReceiptPrintableWid({required this.stand, required this.receiptInfo});

  Future<Uint8List?> getPrintableBytes() async {
    TimeLaps t0 = TimeLaps(tag: "lap_widconv");

    final ScreenshotController screenshotController = ScreenshotController();

    Uint8List capturedImage = await screenshotController.captureFromWidget(
      InheritedTheme.captureAll(
        App.context,
        Material(color: Colors.white, child: receiptWidget()),
      ),
      delay: const Duration(milliseconds: 0),
      context: App.context,
      pixelRatio: 1,
    );
    t0.laps("wid_img");

    return capturedImage;
  }

  double get smallFontSize => 15;
  double get mediumFontSize => 20;
  double get largeFontSize => 28;
  double get extralargeFontSize => 40;

  double get receiptWidth =>
      BlueThurmalPrint.instance.selectedpaperSize.width.toDouble();

  TextStyle get siteNameStyle => TextStyle(
    fontSize: 25,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    // letterSpacing: 1.1,
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

  Divider get divider => Divider(thickness: 1.5);

  Widget receiptWidget([Key? key]) {
    return Container(
      // width: 384, // Standard pixel width for 58mm printers. Use 576 for 80mm.
      width: receiptWidth,
      padding: const EdgeInsets.symmetric(horizontal: 0),

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
          if (stand.siteAddressLine1.isNotEmpty)
            Text(
              stand.siteAddressLine1,
              style: siteNameStyle,
              textAlign: TextAlign.center,
            ),
          if (stand.siteAddressLine2.isNotEmpty)
            Text(
              stand.siteAddressLine2,
              style: siteNameStyle,
              textAlign: TextAlign.center,
            ),
          divider,
          Row(
            spacing: 3,
            children: [
              Text.rich(
                TextSpan(
                  text: "Bill- ",
                  children: [
                    TextSpan(
                      text: receiptInfo.showSaleNumber,

                      style: mediumStyle,
                    ),
                  ],
                ),
                style: mediumStyle,
              ),
              Expanded(
                child: Align(
                  alignment: AlignmentGeometry.centerRight,
                  child: Text(
                    DateTime.now().custumDateFormat("dd-MM-yyy\nhh:mm:ss a"),
                    style: smallStyle.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ],
          ),
          divider,

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

          divider,
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

          divider,
          Table(
            columnWidths: {
              0: FlexColumnWidth(3.5),
              1: FlexColumnWidth(1.5),
              2: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                children: [
                  Text(
                    "Total",
                    style: mediumStyle.copyWith(fontSize: largeFontSize),
                  ),
                  Center(
                    child: Text(
                      receiptInfo.totalItems.thousandText(),
                      style: mediumStyle.copyWith(fontSize: largeFontSize),
                    ),
                  ),
                  Align(
                    alignment: AlignmentGeometry.centerRight,
                    child: Text(
                      receiptInfo.totalAmount.thousandText(),
                      style: mediumStyle.copyWith(fontSize: largeFontSize),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Text(
          //   "Rs.${receiptInfo.totalAmount.thousandText()}",

          //   style: siteNameStyle.copyWith(fontSize: 30),
          // ),
          divider,

          // Text("Thank You! Visit Again", style: mediumStyle),
        ],
      ),
    );
  }
}
