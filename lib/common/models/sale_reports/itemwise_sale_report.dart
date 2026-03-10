import 'package:pos_billing/core/extensions/datetime_ext.dart';
import 'package:pos_billing/core/extensions/parse_value_by_map.dart';

class ItemwiseSaleReport {
  final int siteId;
  final DateTime saleDate;
  final int itemId;
  final String itemName;
  final String itemNameInEnglish;
  final int onlineItemCount;
  final double onlineItemAmount;
  final int cashItemCount;
  final double cashItemAmount;
  final int totalItemCount;
  final double totalItemAmount;

  ItemwiseSaleReport({
    required this.siteId,
    required this.saleDate,
    required this.itemId,
    required this.itemName,
    required this.itemNameInEnglish,
    required this.onlineItemCount,
    required this.onlineItemAmount,
    required this.cashItemCount,
    required this.cashItemAmount,
    required this.totalItemCount,
    required this.totalItemAmount,
  });

  static List<ItemwiseSaleReport> fetchList(
    dynamic data, {
    required bool fromServer,
  }) {
    if (data is List) {
      return List<ItemwiseSaleReport>.from(
        data.map((e) => ItemwiseSaleReport.fromJson(e, fromServer: fromServer)),
      );
    }

    return [];
  }

  Map<String, dynamic> toExcelData() => {
    "Sale Date": saleDate.dateVibleDate,
    "Item Name": itemName,
    "Item Name (InEnglish)": itemNameInEnglish,
    "Online Item Count": onlineItemCount,
    "Online Item Amount": onlineItemAmount,
    "Cash Item Count": cashItemCount,
    "Cash Item Amount": cashItemAmount,
    "Total Item Count": totalItemCount,
    "Total Item Amount": totalItemAmount,
  };

  factory ItemwiseSaleReport.fromJson(
    Map<String, dynamic> json, {
    required bool fromServer,
  }) => ItemwiseSaleReport(
    siteId: json.getint("siteId"),
    saleDate: json.getDateTimeOrNullAccordingSource(
      "saleDate",
      fromServer: fromServer,
    )!,
    itemId: json.getint("itemId"),
    itemName: json.getString("itemName"),
    itemNameInEnglish: json.getString("itemNameInEnglish"),
    onlineItemCount: json.getint("onlineItemCount"),
    onlineItemAmount: json.getdouble("onlineItemAmount"),
    cashItemCount: json.getint("cashItemCount"),
    cashItemAmount: json.getdouble("cashItemAmount"),
    totalItemCount: json.getint("totalItemCount"),
    totalItemAmount: json.getdouble("totalItemAmount"),
  );
}
