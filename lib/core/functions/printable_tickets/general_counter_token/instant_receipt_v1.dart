import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:image/image.dart' as img;
import 'package:pos_billing/common/models/basic/site_detail_model.dart';
import 'package:pos_billing/common/models/sale/receipt_info.dart';
import 'package:pos_billing/core/extensions/datetime_ext.dart';
import 'package:pos_billing/core/extensions/num_ex.dart';
import 'package:pos_billing/core/extensions/printer_widgets.dart';

Future<List<int>> generalCounterTokenBytes({
  required Generator ticket,
  required SiteDetail stand,
  required ReceiptInfo receiptInfo,
}) async {
  List<int> bytes = [];

  final isIndianSite = stand.countryCallingCode == "91";

  bytes += ticket.setGlobalFont(PosFontType.fontA);

  bytes += stand.siteName.ptCnterBold(ticket);
  bytes += stand.siteAddressLine1.ptCnterBold(ticket);
  bytes += stand.siteAddressLine2.ptCnterBold(ticket);

  bytes += ticket.hr();
  // bytes += "Vehicle Details".ptCenter(ticket);

  bytes += "Bill : ${receiptInfo.showSaleNumber}".ptCnterBold(ticket);

  for (var e in formatItem("Item", "Qty", "Amount")) {
    bytes += ticket.text(e);
  }

  bytes += ticket.hr();

  for (var items in receiptInfo.receiptItems) {
    for (var e in formatItem(
      items.itemName,
      items.itemQuantity.thousandText(),
      items.itemAmount.thousandText(),
    )) {
      bytes += ticket.text(e);
    }
  }

  // Advance Payment
  bytes += ticket.hr();

  bytes += "Rs.${receiptInfo.totalAmount.thousandText()}".ptTokenCount(ticket);
  bytes += ticket.hr();
  bytes += DateTime.now()
      .custumDateFormat("dd.MMM.yyy hh:mm:ss a")
      .ptCenter(ticket);

  bytes += 'Thank You! Visit Again'.ptCnterBold(ticket);

  bytes += ticket.cut();
  // bytes += ticket.feed(3);

  return bytes;
}

List<String> formatItem(String name, String qty, String amount) {
  int nameWidth = 18;
  int qtyWidth = 4;
  int amountWidth = 10;

  List<String> lines = [];

  String firstPart = name.length > nameWidth
      ? name.substring(0, nameWidth)
      : name;

  lines.add(
    firstPart.padRight(nameWidth) +
        qty.toString().padRight(qtyWidth) +
        amount.toString().padLeft(amountWidth),
  );

  if (name.length > nameWidth) {
    String remaining = name.substring(nameWidth);
    lines.add(remaining);
  }

  return lines;
}

Future<List<int>> printTamil(Generator generator, String tamilText) async {
  final bytes = <int>[];

  img.Image image = img.Image(400, 80);

  img.fill(image, img.getColor(255, 255, 255));

  img.drawString(
    image,
    img.arial_48,
    10,
    10,
    tamilText,
    color: img.getColor(0, 0, 0),
  );

  bytes.addAll(generator.image(image));

  return bytes;
}
