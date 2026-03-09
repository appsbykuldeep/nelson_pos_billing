import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:pos_billing/core/extensions/datetime_ext.dart';
import 'package:pos_billing/core/extensions/printer_widgets.dart';

Future<List<int>> getTestPrintBytes({required Generator ticket}) async {
  List<int> bytes = [];

  bytes += "Test Token".ptSiteName(ticket);

  bytes += ticket.hr();
  // bytes += "Vehicle Details".ptCenter(ticket);

  bytes += "Token No.".ptLargeBold(ticket);

  bytes += "X".ptTokenCount(ticket);
  // bytes += "#${tokenNumber.thousandText(isIndianSite)}".ptLargeBold(ticket);

  // Advance Payment

  bytes += DateTime.now()
      .custumDateFormat("dd.MMM.yyy hh:mm:ss a")
      .ptCenter(ticket);
  bytes += ticket.hr();

  bytes += 'Thank You! Visit Again'.ptCnterBold(ticket);

  bytes += ticket.cut();
  // bytes += ticket.feed(3);

  return bytes;
}
