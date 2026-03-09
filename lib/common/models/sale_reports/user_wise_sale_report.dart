import 'package:pos_billing/core/extensions/parse_value_by_map.dart';

class UserWiseSaleReport {
  final int saleBy;
  final String userFullName;
  final DateTime saleDate;
  final int totalSaleCount;
  final double onlineSaleAmount;
  final double cashSaleAmount;
  final double totalSaleAmount;

  UserWiseSaleReport({
    required this.saleBy,
    required this.userFullName,
    required this.saleDate,
    required this.totalSaleCount,
    required this.onlineSaleAmount,
    required this.cashSaleAmount,
    required this.totalSaleAmount,
  });

  static List<UserWiseSaleReport> fetchList(
    dynamic data, {
    required bool fromServer,
  }) {
    if (data is List) {
      return List<UserWiseSaleReport>.from(
        data.map((e) => UserWiseSaleReport.fromJson(e, fromServer: fromServer)),
      );
    }

    return [];
  }

  factory UserWiseSaleReport.fromJson(
    Map<String, dynamic> json, {
    required bool fromServer,
  }) {
    return UserWiseSaleReport(
      saleBy: json.getint("saleBy"),
      userFullName: json.getString("userFullName"),
      saleDate: json.getDateTimeOrNullAccordingSource(
        "saleDate",
        fromServer: fromServer,
      )!,
      totalSaleCount: json.getint("totalSaleCount"),
      onlineSaleAmount: json.getdouble("onlineSaleAmount"),
      cashSaleAmount: json.getdouble("cashSaleAmount"),
      totalSaleAmount: json.getdouble("totalSaleAmount"),
    );
  }
}
