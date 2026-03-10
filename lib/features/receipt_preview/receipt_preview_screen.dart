import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pos_billing/common/models/basic/site_detail_model.dart';
import 'package:pos_billing/common/models/sale/receipt_info.dart';
import 'package:pos_billing/common/singletons/printer_ctrl.dart';
import 'package:pos_billing/core/extensions/datetime_ext.dart';
import 'package:pos_billing/core/extensions/num_ex.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';

class ReceiptPreviewScreen extends StatefulWidget {
  final SiteDetail stand;
  final ReceiptInfo receiptInfo;

  const ReceiptPreviewScreen({
    super.key,

    required this.stand,
    required this.receiptInfo,
  });

  static const String routeName = "/ReceiptPreviewScreen";

  @override
  State<ReceiptPreviewScreen> createState() => _ReceiptPreviewScreenState();
}

class _ReceiptPreviewScreenState extends State<ReceiptPreviewScreen> {
  final GlobalKey repaintKey = GlobalKey();
  final printer = BlueThurmalPrint.instance;
  double get smallFontSize => 15;

  double get mediumFontSize => 20;

  double get largeFontSize => 28;

  double get extralargeFontSize => 40;

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

  Future<void> printReceipt() async {
    final status = await printer.printReceiptViaPreview(
      receiptInfo: await getPrintReceipt(),
    );

    if (!status.status) {
      status.msj.showToast;
    }
  }

  Future<Uint8List> getPrintReceipt() async {
    RenderRepaintBoundary boundary =
        repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 2);

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preview"),
        actions: [FilledButton(onPressed: printReceipt, child: Text("print"))],
      ),
      body: Center(
        child: RepaintBoundary(
          key: repaintKey,
          child: Container(
            // width: 384, // Standard pixel width for 58mm printers. Use 576 for 80mm.
            width: BlueThurmalPrint.instance.selectedpaperSize.width.toDouble(),
            padding: const EdgeInsets.symmetric(horizontal: 5),

            decoration: BoxDecoration(
              border: Border.all(),
              color: Colors.white,
            ),
            child: Column(
              spacing: 0,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.stand.siteName,
                  style: siteNameStyle,
                  textAlign: TextAlign.center,
                ),
                if (widget.stand.siteAddressLine1.isNotEmpty)
                  Text(
                    widget.stand.siteAddressLine1,
                    style: siteNameStyle,
                    textAlign: TextAlign.center,
                  ),
                if (widget.stand.siteAddressLine2.isNotEmpty)
                  Text(
                    widget.stand.siteAddressLine2,
                    style: siteNameStyle,
                    textAlign: TextAlign.center,
                  ),
                Divider(thickness: 1.5),
                Row(
                  spacing: 3,
                  children: [
                    Text(
                      "Bill: ${widget.receiptInfo.showSaleNumber}",
                      style: smallStyle,
                    ),
                    Expanded(
                      child: Align(
                        alignment: AlignmentGeometry.centerRight,
                        child: Text(
                          DateTime.now().custumDateFormat(
                            "dd-MM-yyy hh:mm:ss a",
                          ),
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
                    for (var e in widget.receiptInfo.receiptItems)
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
                Table(
                  columnWidths: {
                    0: FlexColumnWidth(3.5),
                    1: FlexColumnWidth(1.5),
                    2: FlexColumnWidth(2),
                  },
                  children: [
                    TableRow(
                      children: [
                        Text("Total", style: mediumStyle),
                        Center(
                          child: Text(
                            widget.receiptInfo.totalItems.thousandText(),
                            style: mediumStyle,
                          ),
                        ),
                        Align(
                          alignment: AlignmentGeometry.centerRight,
                          child: Text(
                            widget.receiptInfo.totalAmount.thousandText(),
                            style: mediumStyle,
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
                Divider(thickness: 1.5),

                // Text("Thank You! Visit Again", style: mediumStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
