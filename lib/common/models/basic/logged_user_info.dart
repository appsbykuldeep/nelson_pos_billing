import 'dart:convert';

import 'package:pos_billing/core/extensions/localdb_ext.dart';
import 'package:pos_billing/core/extensions/parse_value_by_map.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';
import 'package:pos_billing/core/functions/string_encryter.dart';

class LoggedUserInfo {
  final bool loginStatus;
  final String loginId;
  final String loginPasswordMD5;
  final String lastLoginKey;
  final DateTime? lastLoginOn;

  /// It is user's unique Id
  final int userId;
  final int userStandId;
  LoggedUserInfo({
    this.loginStatus = false,
    this.loginId = '',
    this.loginPasswordMD5 = '',
    this.lastLoginKey = '',
    this.userId = 0,
    this.userStandId = 0,
    this.lastLoginOn,
  });

  Map<String, dynamic> _toMap() {
    return <String, dynamic>{
      'loginStatus': loginStatus,
      'loginId': loginId,
      'loginPassword': loginPasswordMD5,
      'lastLoginKey': lastLoginKey,
      'userId': userId,
      'userStandId': userStandId,
      "lastLoginOn": lastLoginOn?.toString(),
    };
  }

  static LoggedUserInfo getFromBoxStorage() {
    try {
      final info = "".boxLoggedUserInfo;

      if (info.isNotEmpty) {
        return LoggedUserInfo._fromMap(jsonDecode(decryptStringV1(info)));
      }
    } catch (e) {
      return LoggedUserInfo();
    }
    return LoggedUserInfo();
  }

  void saveToBoxStorage() {
    encryptStringV1(jsonEncode(_toMap())).boxLoggedUserInfo;
  }

  void logoutUser() {
    "--".boxLoggedUserInfo;
  }

  factory LoggedUserInfo._fromMap(Map<String, dynamic> map) {
    "getFromBoxStorage : $map".developerLog();
    return LoggedUserInfo(
      loginStatus: map['loginStatus'] ?? false,
      loginId: map['loginId'] ?? '',
      loginPasswordMD5: map['loginPassword'] ?? '',
      lastLoginKey: map['lastLoginKey'] ?? '',
      userId: map['userId']?.toInt() ?? 0,
      userStandId: map['userStandId']?.toInt() ?? 0,
      lastLoginOn: map.getDateTimeOrNull("lastLoginOn"),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LoggedUserInfo &&
        other.loginStatus == loginStatus &&
        other.loginId == loginId &&
        other.loginPasswordMD5 == loginPasswordMD5 &&
        other.userId == userId &&
        other.userStandId == userStandId;
  }

  @override
  int get hashCode {
    return loginStatus.hashCode ^
        loginId.hashCode ^
        loginPasswordMD5.hashCode ^
        userId.hashCode ^
        userStandId.hashCode;
  }
}
