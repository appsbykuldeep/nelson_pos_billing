import 'package:pos_billing/common/models/item/item_info.dart';
import 'package:pos_billing/common/singletons/unique_code_v2.dart';
import 'package:pos_billing/config/enums/current_status.dart';
import 'package:pos_billing/core/extensions/datetime_ext.dart';
import 'package:pos_billing/core/extensions/parse_value_by_map.dart';

class ReceiptItem extends ItemInfo {
  int itemQuantity;

  ReceiptItem({
    required super.itemId,
    required super.itemName,
    required super.itemRate,
    super.siteId,
    super.currentStatus,
    super.updatedBy,
    super.updatedOn,
    super.updatedByFullName,
    this.itemQuantity = 0,
  });

  double get itemAmount => itemQuantity * itemRate;
  late final String saleItemUID = UniqueCodeV2.uuid();

  static List<ReceiptItem> get damiData => [
    ReceiptItem(itemId: 1, itemName: "பெரியவர்", itemRate: 5),
    ReceiptItem(itemId: 2, itemName: "சிரியவர்", itemRate: 6),
    ReceiptItem(itemId: 3, itemName: "இரு சக்கர வாகனம்", itemRate: 7),
    ReceiptItem(itemId: 4, itemName: "நான்கு சக்கர வாகனம்", itemRate: 8),
    ReceiptItem(itemId: 5, itemName: "வேன் / பஸ்", itemRate: 9),
  ];

  static List<ReceiptItem> fetchList(dynamic data, {required bool fromServer}) {
    if (data is List) {
      return List<ReceiptItem>.from(
        data.map((e) => ReceiptItem.fromMap(e, fromServer: fromServer)),
      );
    }

    return [];
  }

  Map<String, dynamic> toMap() => {
    "itemId": itemId,
    "itemName": itemName,
    "itemRate": itemRate,
    "siteId": siteId,
    "currentStatus": currentStatus.id,
    "updatedOn": updatedOn?.toINDDateTime.toString(),
    "updatedBy": updatedBy,
    "updatedByFullName": updatedByFullName,
    "itemQuantity": itemQuantity,
  };

  Map<String, dynamic> toSyncMap(
    String saleUID,
    int saleBy,
    DateTime? issueOn,
  ) => {
    "saleItemUID": saleItemUID,
    "saleUID": saleUID,
    "itemId": itemId,
    "itemQuantity": itemQuantity,
    "itemAmount": itemAmount,
    "currentStatus": currentStatus.id,
    "updateBy": saleBy,
    "updateOn": issueOn?.toINDDateTime.toString(),
    "isSyncedToServer": 0,
    'syncedOnServer': null,
  };

  static ReceiptItem fromItemMaster(ItemInfo info) {
    return ReceiptItem(
      itemId: info.itemId,
      itemName: info.itemName,
      itemRate: info.itemRate,
      siteId: info.siteId,
    );
  }

  @override
  factory ReceiptItem.fromMap(
    Map<String, dynamic> json, {
    required bool fromServer,
  }) {
    return ReceiptItem(
      itemId: json.getint("itemId"),
      itemName: json.getString("itemName"),
      itemRate: json.getdouble("itemRate"),
      siteId: json.getint("siteId"),
      currentStatus: CurrentStatus.byId(json.getint("currentStatus")),
      updatedOn: json.getDateTimeOrNullAccordingSource(
        "updatedOn",
        fromServer: fromServer,
      ),
      updatedBy: json.getint("updatedBy"),
      updatedByFullName: json.getString("updatedByFullName"),
      itemQuantity: json.getint("itemQuantity"),
    );
  }
}
