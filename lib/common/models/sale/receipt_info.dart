import 'package:pos_billing/config/enums/current_status.dart';
import 'package:pos_billing/config/enums/payment_mode.dart';
import 'package:pos_billing/core/extensions/datetime_ext.dart';
import 'package:pos_billing/core/extensions/num_ex.dart';
import 'package:pos_billing/core/extensions/parse_value_by_map.dart';

import 'receipt_item.dart';

class ReceiptInfo {
  final String saleUID;
  final DateTime? saleOn;
  final int saleBy;
  final int siteId;
  final String saleByFullName;
  final int tokenNumber;
  final int totalItems;
  final double totalAmount;
  final PaymentMode paymentMode;
  final CurrentStatus currentStatus;
  final int isSyncedToServer;
  final DateTime? syncedOnServer;
  final String remark;
  final List<ReceiptItem> receiptItems;

  ReceiptInfo({
    this.saleUID = '',
    this.saleOn,
    this.saleBy = 0,
    this.siteId = 0,
    this.saleByFullName = '',
    this.tokenNumber = 0,
    this.totalItems = 0,
    this.totalAmount = 0,
    this.paymentMode = PaymentMode.cash,
    this.currentStatus = CurrentStatus.active,
    this.isSyncedToServer = 0,
    this.syncedOnServer,
    this.remark = '',
    this.receiptItems = const [],
  });

  String get showSaleNumber =>
      tokenNumber > 0 ? tokenNumber.thousandText() : saleUID.split("@").last;

  Map<String, dynamic> toMap() => {
    "saleUID": saleUID,
    "saleOn": saleOn?.toString(),
    "saleBy": saleBy,
    "saleByFullName": saleByFullName,
    "tokenNumber": tokenNumber,
    "totalItems": totalItems,
    "totalAmount": totalAmount,
    "remark": remark,
    "paymentMode": paymentMode.id,
    "currentStatus": currentStatus.id,
    "isSyncedToServer": isSyncedToServer,
    "syncedOnServer": syncedOnServer?.toString(),
    "receiptItems": receiptItems.map((e) => e.toMap()).toList(),
  };

  Map<String, dynamic> toSyncMap() => {
    "saleUID": saleUID,
    "saleOn": saleOn?.toINDDateTime.toString(),
    "saleBy": saleBy,
    "siteId": siteId,
    "totalItems": totalItems,
    "totalAmount": totalAmount,
    "paymentMode": paymentMode.id,
    "remark": remark,
    "receiptItems": receiptItems
        .map((e) => e.toSyncMap(saleUID, saleBy, saleOn))
        .toList(),
  };

  List<Map<String, dynamic>> toExcelRow() {
    return receiptItems
        .map(
          (e) => {
            "Sale UID": saleUID,
            "Sale On": saleOn?.toINDDateTime.dateVibleDateStamp,
            "Sale By": saleByFullName,
            "Bill Number": showSaleNumber,
            "Item Name": e.itemName,
            "Item Rate": e.itemRate,
            "Item Quantity": e.itemQuantity,
            "Item Amount": e.itemAmount,
            "Payment Mode": paymentMode.lable,
          },
        )
        .toList();
  }

  static List<ReceiptInfo> fetchList(dynamic data, {required bool fromServer}) {
    if (data is List) {
      return List<ReceiptInfo>.from(
        data.map((e) => ReceiptInfo.fromJson(e, fromServer: fromServer)),
      );
    }

    return [];
  }

  factory ReceiptInfo.fromJson(
    Map<String, dynamic> json, {
    required bool fromServer,
  }) {
    return ReceiptInfo(
      saleUID: json.getString("saleUID"),
      saleOn: json.getDateTimeOrNullAccordingSource(
        "saleOn",
        fromServer: fromServer,
      ),
      saleBy: json.getint("saleBy"),
      saleByFullName: json.getString("saleByFullName"),
      tokenNumber: json.getint("tokenNumber"),
      totalItems: json.getint("totalItems"),
      totalAmount: json.getdouble("totalAmount"),
      currentStatus: CurrentStatus.byId(json.getint("currentStatus")),
      isSyncedToServer: json.getint("isSyncedToServer"),
      syncedOnServer: json.getDateTimeOrNullAccordingSource(
        "syncedOnServer",
        fromServer: fromServer,
      ),
      remark: json.getString("remark"),
      receiptItems: ReceiptItem.fetchList(
        json.getValue("receiptItems"),
        fromServer: fromServer,
      ),
    );
  }

  ReceiptInfo copyWith({
    String? saleUID,
    DateTime? saleOn,
    int? saleBy,
    int? siteId,
    String? saleByFullName,
    int? tokenNumber,
    int? totalItems,
    double? totalAmount,
    CurrentStatus? currentStatus,
    int? isSyncedToServer,
    DateTime? syncedOnServer,
    String? remark,
    List<ReceiptItem>? receiptItems,
  }) {
    return ReceiptInfo(
      saleUID: saleUID ?? this.saleUID,
      saleOn: saleOn ?? this.saleOn,
      saleBy: saleBy ?? this.saleBy,
      siteId: siteId ?? this.siteId,
      saleByFullName: saleByFullName ?? this.saleByFullName,
      tokenNumber: tokenNumber ?? this.tokenNumber,
      totalItems: totalItems ?? this.totalItems,
      totalAmount: totalAmount ?? this.totalAmount,
      currentStatus: currentStatus ?? this.currentStatus,
      isSyncedToServer: isSyncedToServer ?? this.isSyncedToServer,
      syncedOnServer: syncedOnServer ?? this.syncedOnServer,
      remark: remark ?? this.remark,
      receiptItems: receiptItems ?? this.receiptItems,
    );
  }
}
