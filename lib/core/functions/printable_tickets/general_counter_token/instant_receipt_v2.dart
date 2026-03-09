// import 'package:pos_billing/common/models/basic/site_detail_model.dart';
// import 'package:pos_billing/common/models/sale/receipt_info.dart';
// import 'package:pos_billing/core/extensions/datetime_ext.dart';
// import 'package:unified_esc_pos_printer/unified_esc_pos_printer.dart';

// Future<List<int>> generateReceiptV2({
//   required Ticket ticket,
//   required SiteDetail stand,
//   required ReceiptInfo receiptInfo,
// }) async {
//   final isIndianSite = stand.countryCallingCode == "91";

//   final ticket = await Ticket.create(PaperSize.mm58);

//   ticket.text(stand.siteName);
//   ticket.text(stand.siteAddressLine1);
//   ticket.text(stand.siteAddressLine2);

//   ticket.separator();

//   ticket.text("Bill : ${receiptInfo.showSaleNumber}");

//   // 3-column layout with header
//   ticket.row([
//     PrintColumn(text: 'Item', flex: 5, style: const PrintTextStyle(bold: true)),
//     PrintColumn(
//       text: 'Qty',
//       flex: 3,
//       align: PrintAlign.center,
//       style: const PrintTextStyle(bold: true),
//     ),
//     PrintColumn(
//       text: 'Total',
//       flex: 4,
//       align: PrintAlign.right,
//       style: const PrintTextStyle(bold: true),
//     ),
//   ]);

//   // Advance Payment
//   ticket.separator();
//   ticket.text(DateTime.now().custumDateFormat("dd.MMM.yyy hh:mm:ss a"));

//   ticket.text('Thank You! Visit Again');

//   ticket.cut();

//   return [];
// }
