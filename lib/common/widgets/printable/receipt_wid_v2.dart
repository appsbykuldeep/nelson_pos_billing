import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:pos_billing/common/models/basic/site_detail_model.dart';
import 'package:pos_billing/common/models/sale/receipt_info.dart';
import 'package:pos_billing/config/constants/assets.dart';

class ReceiptPrintableWidV2 {
  final SiteDetail stand;
  final ReceiptInfo receiptInfo;
  const ReceiptPrintableWidV2({required this.stand, required this.receiptInfo});

  img.BitmapFont get smallFontSize => otherFont!;
  img.BitmapFont get mediumFontSize => otherFont!;
  img.BitmapFont get largeFontSize => otherFont!;
  // img.BitmapFont get smallFontSize => img.arial_14;
  // img.BitmapFont get mediumFontSize => img.arial_24;
  // img.BitmapFont get largeFontSize => img.arial_48;

  static img.BitmapFont? otherFont;

  Future<img.BitmapFont> loadFont() async {
    final data = await rootBundle.load(Assets.fontsNotoSansSemiBold);
    return img.BitmapFont.fromZip(data.buffer.asUint8List());
  }

  Future<img.Image> createReceipt() async {
    int width = 384; // 58mm printer
    int height = 2000;

    otherFont ??= await loadFont();

    img.Image receipt = img.Image(width, height);

    img.fill(receipt, img.getColor(255, 255, 255));

    int y = 10;

    y = drawCenter(receipt, stand.siteName, y);
    y = drawCenter(receipt, stand.siteAddressLine1, y);
    y = drawCenter(receipt, stand.siteAddressLine2, y);

    y = drawDivider(receipt, y);

    y = drawLeftRight(
      receipt,
      "Bill: ${receiptInfo.showSaleNumber}",
      DateTime.now().toString(),
      y,
    );

    y = drawDivider(receipt, y);

    y = drawHeader(receipt, y);

    y = drawDivider(receipt, y);

    for (var e in receiptInfo.receiptItems) {
      y = drawRow(
        receipt,
        e.itemName,
        e.itemQuantity.toString(),
        e.itemAmount.toString(),
        y,
      );
    }

    y = drawDivider(receipt, y);

    y = drawRow(
      receipt,
      "Total",
      receiptInfo.totalItems.toString(),
      receiptInfo.totalAmount.toString(),
      y,
    );

    return img.copyCrop(receipt, 0, 0, width, y + 20);
  }

  int drawCenter(img.Image image, String text, int y) {
    var font = largeFontSize;

    int tWidth = textWidth(font, text);

    int x = (image.width - tWidth) ~/ 2;

    img.drawString(image, font, x, y, text, color: img.getColor(0, 0, 0));

    return y + font.lineHeight + 5;
  }

  int drawDivider(img.Image image, int y) {
    img.drawLine(image, 0, y, image.width, y, img.getColor(0, 0, 0));

    return y + 10;
  }

  int drawLeftRight(img.Image image, String left, String right, int y) {
    var font = img.arial_14;

    img.drawString(image, font, 5, y, left, color: img.getColor(0, 0, 0));

    int w = textWidth(font, right);

    img.drawString(
      image,
      font,
      image.width - w - 5,
      y,
      right,
      color: img.getColor(0, 0, 0),
    );

    return y + 25;
  }

  int drawHeader(img.Image image, int y) {
    var font = img.arial_14;

    img.drawString(image, font, 5, y, "Item", color: img.getColor(0, 0, 0));
    img.drawString(image, font, 230, y, "Qty", color: img.getColor(0, 0, 0));
    img.drawString(image, font, 310, y, "Amt", color: img.getColor(0, 0, 0));

    return y + 25;
  }

  int drawRow(img.Image image, String item, String qty, String amt, int y) {
    var font = img.arial_14;

    img.drawString(image, font, 5, y, item, color: img.getColor(0, 0, 0));

    img.drawString(image, font, 230, y, qty, color: img.getColor(0, 0, 0));

    int w = textWidth(font, amt);

    img.drawString(
      image,
      font,
      image.width - w - 5,
      y,
      amt,
      color: img.getColor(0, 0, 0),
    );

    return y + 25;
  }

  int textWidth(img.BitmapFont font, String text) {
    int width = 0;

    for (int i = 0; i < text.length; i++) {
      int code = text.codeUnitAt(i);

      var glyph = font.characters[code];

      if (glyph != null) {
        width += glyph.xadvance;
      }
    }

    return width;
  }
}
