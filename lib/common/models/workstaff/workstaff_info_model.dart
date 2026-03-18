import 'package:pos_billing/common/models/workstaff/workstaffmaster_model.dart';
import 'package:pos_billing/config/enums/current_status.dart';
import 'package:pos_billing/config/enums/user_roles.dart';
import 'package:pos_billing/core/extensions/parse_value_by_map.dart';

class WorkstaffInfoModel extends WorkingStaffMaster {
  final bool isOnline;
  WorkstaffInfoModel({
    this.isOnline = false,
    super.userId = 0,
    super.fullName = '',
    super.mobile = '',
    super.role = UserRole.none,
    super.currentStatus = CurrentStatus.active,
    super.siteId = 0,
    super.createOn,
    super.lastLogin,
    super.allowedItemsForSale,
    super.profileImageBaseURLPath,
  });

  //fetchList
  static List<WorkstaffInfoModel> fetchList(
    dynamic data, {
    required bool fromServer,
    Set<int>? onlineUsersCodes,
  }) {
    if (data == null) return [];

    try {
      return List<WorkstaffInfoModel>.from(
        (data as List<dynamic>).map(
          (e) => WorkstaffInfoModel.fromJson(
            e,
            fromServer: fromServer,
            onlineUsersCodes: onlineUsersCodes,
          ),
        ),
      ).toList();
    } catch (e) {
      return [];
    }
  }

  factory WorkstaffInfoModel.byWorkingStaffMaster(
    WorkingStaffMaster workStaff, {
    List<int> onlineUsersCodes = const [],
  }) {
    return WorkstaffInfoModel(
      isOnline: onlineUsersCodes.contains(workStaff.userId),
      userId: workStaff.userId,

      fullName: workStaff.fullName,
      mobile: workStaff.mobile,

      role: workStaff.role,

      currentStatus: workStaff.currentStatus,

      siteId: workStaff.siteId,

      createOn: workStaff.createOn,
      lastLogin: workStaff.lastLogin,
      allowedItemsForSale: workStaff.allowedItemsForSale,
      profileImageBaseURLPath: workStaff.profileImageBaseURLPath,
    );
  }

  //fromJson

  @override
  factory WorkstaffInfoModel.fromJson(
    Map<String, dynamic> json, {
    required bool fromServer,
    Set<int>? onlineUsersCodes,
  }) {
    final userId = json.getint("userId");
    return WorkstaffInfoModel(
      isOnline: onlineUsersCodes?.contains(userId) ?? false,
      userId: json.getint("userId"),

      fullName: json.getString("userFullName"),
      mobile: json.getString("userMobile"),

      role: UserRole.byValue(json.getString("roleId")),
      profileImageBaseURLPath: json.getString("profileImagePath"),

      currentStatus: CurrentStatus.byId(json.getint("currentStatus")),

      siteId: json.getint("siteId"),

      allowedItemsForSale: WorkingStaffMaster.parseNonEmptyIdsList(
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
