import 'dart:convert';

import 'package:pos_billing/common/classes/parse_map_value.dart';
import 'package:pos_billing/config/constants/node_apis.dart';
import 'package:pos_billing/config/enums/current_status.dart';
import 'package:pos_billing/config/enums/user_roles.dart';
import 'package:pos_billing/core/extensions/datetime_ext.dart';
import 'package:pos_billing/core/extensions/localdb_ext.dart';

class UserDetails {
  UserDetails({
    this.userId = 0,
    this.siteId = 0,
    this.userFullName = '',
    this.userMobile = '',
    this.userEmail = '',
    this.bankName = '',
    this.accountNumber = '',
    this.iFSCCode = '',
    this.accountHolderName = '',
    this.sWIFTCode = '',
    this.role = UserRole.none,
    this.currentStatus = CurrentStatus.active,
    this.lastLoginKey = '',
    this.loginOn,
    this.profileImagePath = '',
    this.companyId = 1,
    this.allowedItemsForSale = const [],
  });

  final int userId;
  final int siteId;
  final int companyId;
  final String userFullName;
  final String userMobile;
  final String userEmail;
  final String bankName;
  final String accountNumber;
  final String iFSCCode;
  final String accountHolderName;
  final String sWIFTCode;
  final UserRole role;
  final CurrentStatus currentStatus;
  final DateTime? loginOn;
  final String lastLoginKey;
  final String profileImagePath;
  final List<int> allowedItemsForSale;

  static UserDetails fetch(dynamic data, {required bool fromServer}) {
    if (data == null) return UserDetails();
    return UserDetails.fromJson(data, fromServer: fromServer);
  }

  bool get isOwnerOrStandAdmin => siteId > 0 && role.isOwnerOrAdmin;
  bool get isLoggedIn => siteId > 0 && userId > 0 && currentStatus.isActive;

  static List<int> _parseIntListByCsv(String val) {
    return val
        .split(",")
        .map((e) => int.tryParse(e) ?? 0)
        .where((e) => e > 0)
        .toList();
  }

  factory UserDetails.fromJson(
    Map<String, dynamic> json, {
    required bool fromServer,
  }) {
    final parser = ParseMapValue(input: json);
    final profileBaseurl = parser.getString("ProfileImageBaseURLPath");
    return UserDetails(
      userId: parser.getint("userId"),

      siteId: parser.getint("siteId"),
      companyId: parser.getint("companyId"),
      userFullName: parser.getString("userFullName"),
      userMobile: parser.getString("userMobile"),
      // userEmail: parser.getString("EmailId"),
      // bankName: parser.getString("bankName"),
      // accountNumber: parser.getString("accountNumber"),
      // iFSCCode: parser.getString("iFSCCode"),
      // accountHolderName: parser.getString("accountHolderName"),
      // sWIFTCode: parser.getString("sWIFTCode"),
      role: UserRole.byValue(parser.getString("roleId")),
      lastLoginKey: parser.getString("loginKey"),
      loginOn: parser.getDateTimeOrNullAccordingSource(
        "LoginOn",
        fromServer: fromServer,
      ),

      // profileImagePath: imgName.isEmpty
      //     ? ""
      //     : "${ProfileimageHandler.profileImageDir}/$imgName",
      profileImagePath: profileBaseurl.isEmpty
          ? ""
          : "${NodeApis.apihost}/$profileBaseurl",

      allowedItemsForSale: _parseIntListByCsv(
        parser.getString("allowedItemsForSale"),
      ),
      // profileImagePath: profileBaseurl.isEmpty
      //     ? ""
      //     : "${ApiList.baseapi}/$profileBaseurl",
    );
  }

  Map<String, dynamic> toMap() => {
    "StandId": siteId,
    "userId": userId,
    "FullName": userFullName,
    "Mobile": userMobile,
    "EmailId": userEmail,
    "bankName": bankName,
    "accountNumber": accountNumber,
    "iFSCCode": iFSCCode,
    "accountHolderName": accountHolderName,
    "sWIFTCode": sWIFTCode,

    "Role": role.lable,
    "currentStatus": currentStatus,
    "LastLoginKey": lastLoginKey,
    "LoginOn": loginOn?.dateTimeStanderedFormat,

    "ProfileImageName": profileImagePath.split("/").last,
  };

  void saveInBox() {
    jsonEncode(toMap()).boxCurrentUserDetails;
  }

  static UserDetails? getFromBox() {
    try {
      final info = "".boxCurrentUserDetails;
      if (info.isNotEmpty) {
        return UserDetails.fromJson(jsonDecode(info), fromServer: false);
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
