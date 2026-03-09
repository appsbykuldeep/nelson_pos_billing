import 'package:pos_billing/common/data_source/local_source/local_db.dart';
import 'package:pos_billing/config/enums/current_status.dart';
import 'package:pos_billing/core/extensions/parse_value_by_map.dart';

class ItemInfo {
  final int itemId;
  final String itemName;
  final String itemNameInEnglish;
  final double itemRate;
  final int siteId;
  final CurrentStatus currentStatus;
  final DateTime? updatedOn;
  final int updatedBy;
  final String updatedByFullName;

  ItemInfo({
    required this.itemId,
    required this.itemName,
    this.itemNameInEnglish = '',
    required this.itemRate,
    this.siteId = 0,
    this.currentStatus = CurrentStatus.active,
    this.updatedOn,
    this.updatedBy = 0,
    this.updatedByFullName = '',
  });

  Map<String, dynamic> toDbMap() => {
    "itemId": itemId,
    "itemName": itemName,
    "itemNameInEnglish": itemNameInEnglish,
    "itemRate": itemRate,
    "siteId": siteId,
    "currentStatus": currentStatus.id,
    "updatedOn": updatedOn.toString(),
    "updatedBy": updatedBy,
    "updatedByFullName": updatedByFullName,
  };

  static List<ItemInfo> fetchList(dynamic data, {required bool fromServer}) {
    if (data is List) {
      return List<ItemInfo>.from(
        data.map((e) => ItemInfo.fromMap(e, fromServer: fromServer)),
      );
    }

    return [];
  }

  factory ItemInfo.fromMap(
    Map<String, dynamic> json, {
    required bool fromServer,
  }) {
    return ItemInfo(
      itemId: json.getint("itemId"),
      itemName: json.getString("itemName"),
      itemNameInEnglish: json.getString("itemNameInEnglish"),
      itemRate: json.getdouble("itemRate"),
      siteId: json.getint("siteId"),
      currentStatus: CurrentStatus.byId(json.getint("currentStatus")),
      updatedOn: json.getDateTimeOrNullAccordingSource(
        "updatedOn",
        fromServer: fromServer,
      ),
      updatedBy: json.getint("updatedBy"),
      updatedByFullName: json.getString("updatedByFullName"),
    );
  }

  static DBTable dbTable = ("itemInfo", dbColumns, "itemId");

  static Set<DBColumnInfo> dbColumns = {
    ("itemId", String, null),
    ("itemName", String, null),
    ("itemNameInEnglish", String, null),
    ("itemRate", double, 0),
    ("siteId", int, 0),
    ("currentStatus", int, 1),
    ("updatedOn", DateTime, null),
    ("updatedBy", int, null),
    ("updatedByFullName", String, null),
  };
}
