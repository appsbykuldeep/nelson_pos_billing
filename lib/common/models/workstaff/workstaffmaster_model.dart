import 'dart:convert';

import 'package:pos_billing/config/enums/current_status.dart';
import 'package:pos_billing/config/enums/user_roles.dart';
import 'package:pos_billing/core/extensions/parse_value_by_map.dart';

class WorkingStaffMaster {
  WorkingStaffMaster({
    this.userId = 0,
    this.fullName = '',
    this.mobile = '',
    this.role = UserRole.none,
    this.profileImageBaseURLPath = '',
    this.currentStatus = CurrentStatus.active,
    this.siteId = 0,
    this.createOn,
    this.lastLogin,
    this.allowedItemsForSale = const [],
  });

  int userId;
  String fullName;
  String mobile;
  UserRole role;

  CurrentStatus currentStatus;
  int siteId;
  String profileImageBaseURLPath;

  List<int> allowedItemsForSale;
  DateTime? lastLogin;
  DateTime? createOn;

  // bool get isOwner => role.isOwner;

  // String get profileImagePath => profileImageName.isEmpty
  //     ? ''
  //     : "${ProfileimageHandler.profileImageDir}/$profileImageName";

  //fetchList
  static List<WorkingStaffMaster> fetchList(
    dynamic data, {
    required bool fromServer,
  }) {
    if (data == null) return [];
    try {
      return List<WorkingStaffMaster>.from(
        (data as List<dynamic>).map(
          (e) => WorkingStaffMaster.fromJson(e, fromServer: fromServer),
        ),
      ).toList();
    } catch (e) {
      return [];
    }
  }

  static List<int> parseNonEmptyIdsList(String value) {
    if (value.startsWith("[") && value.endsWith("]")) {
      return List<int>.from((jsonDecode(value) as List));
    }

    return value
        .split(",")
        .map((e) => int.tryParse(e) ?? 0)
        .where((e) => e > 0)
        .toList();
  }

  //fromJson
  factory WorkingStaffMaster.fromJson(
    Map<String, dynamic> json, {
    required bool fromServer,
  }) {
    return WorkingStaffMaster(
      userId: json.getint("userId"),

      fullName: json.getString("userFullName"),
      mobile: json.getString("userMobile"),

      role: UserRole.byValue(json.getString("roleId")),
      profileImageBaseURLPath: json.getString("profileImagePath"),

      currentStatus: CurrentStatus.byId(json.getint("currentStatus")),

      siteId: json.getint("siteId"),

      allowedItemsForSale: parseNonEmptyIdsList(
        json.fetchString(["allowedItemsForSale"]),
      ),
      createOn: json.getDateTimeOrNullAccordingSource(
        "createdOn",
        fromServer: fromServer,
      ),
      lastLogin: json.getDateTimeOrNullAccordingSource(
        "LastLoginOn",
        fromServer: fromServer,
      ),
    );
  }
}
