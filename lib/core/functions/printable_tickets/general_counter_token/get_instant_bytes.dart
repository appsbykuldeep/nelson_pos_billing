import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:pos_billing/common/models/basic/site_detail_model.dart';
import 'package:pos_billing/common/models/sale/receipt_info.dart';
import 'package:pos_billing/common/widgets/printable/receipt_wid.dart';
import 'package:pos_billing/common/widgets/printable/receipt_wid_v2.dart';
import 'package:pos_billing/core/functions/printable_tickets/get_printable_ticket_image.dart';

import 'instant_receipt_v1.dart';

Future<List<int>> getInstantReceiptPrintableBytes({
  required Generator ticket,
  required SiteDetail stand,
  required ReceiptInfo receiptInfo,
}) async {
  if (1 == 0) {
    return await getPrintableTicketImageByImage(
      ticket: ticket,
      baseimage: await ReceiptPrintableWidV2(
        stand: stand,
        receiptInfo: receiptInfo,
      ).createReceipt(),
    );
  }
  if (1 == 1) {
    return await getPrintableTicketImageByImage(
      ticket: ticket,
      imageBase64: await ReceiptPrintableWid(
        stand: stand,
        receiptInfo: receiptInfo,
      ).getPrintableBytes(),
    );
  }

  return await generalCounterTokenBytes(
    ticket: ticket,
    stand: stand,
    receiptInfo: receiptInfo,
  );
}
