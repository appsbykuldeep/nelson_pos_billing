// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:pos_billing/common/models/basic/apiresponse_model.dart';
import 'package:pos_billing/common/models/basic/country_codes_model.dart';
import 'package:pos_billing/common/models/basic/logged_user_info.dart';
import 'package:pos_billing/common/models/basic/site_detail_model.dart';
import 'package:pos_billing/common/models/basic/user_details_model.dart';
import 'package:pos_billing/common/models/item/item_info.dart';
import 'package:pos_billing/common/singletons/app.dart';
import 'package:pos_billing/common/singletons/base_api_handler.dart';
import 'package:pos_billing/common/singletons/country_picker_handler.dart';
import 'package:pos_billing/common/singletons/device_package_info.dart';
import 'package:pos_billing/common/singletons/internet_connectivity.dart';
import 'package:pos_billing/config/constants/assets.dart';
import 'package:pos_billing/config/constants/node_apis.dart';
import 'package:pos_billing/config/enums/user_roles.dart';
import 'package:pos_billing/core/extensions/bool_ext.dart';
import 'package:pos_billing/core/extensions/datetime_ext.dart';
import 'package:pos_billing/core/extensions/localdb_ext.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';
import 'package:pos_billing/core/functions/api_call_function.dart';

class LoginUtil {
  LoginUtil._();

  static final LoginUtil _instance = LoginUtil._();

  static LoginUtil get instance => _instance;

  // VPA230,Ge@856406 -- StandId : 24
  // VPA241,Ge@856406
  // VPA836,Ge@856406 -- Parking Boss
  // VPA286 => Bimlesh Bhatindah Fall
  // VPA625 => SVE PARKING SERVICES -- StandId : 314

  /// This class holds alredy login user info in local storage
  late LoggedUserInfo loggedUserInfo = LoggedUserInfo.getFromBoxStorage();

  ValueNotifier<UserDetails> userNotifier = ValueNotifier(UserDetails());
  ValueNotifier<SiteDetail> standDetailsNotifier = ValueNotifier(
    SiteDetail.withConfig(),
  );

  ValueNotifier<String> profileImage = ValueNotifier<String>(
    Assets.imagesMalePerson,
  );

  ValueNotifier<List<ItemInfo>> currentItems = ValueNotifier([]);

  // Get Methods

  int get userId => userNotifier.value.userId;
  int get siteId => standDetailsNotifier.value.siteId;

  UserRole get userRole => userNotifier.value.role;
  bool get isOwnerManagerStandAdmin => userNotifier.value.role.isOwnerOrAdmin;
  bool get isOwnerOrStandAdmin => userNotifier.value.isOwnerOrStandAdmin;
  bool get isLoggedIn => userNotifier.value.isLoggedIn;

  bool get isIndianStand =>
      standDetailsNotifier.value.countryCallingCode == "91";

  String get defCountryCode => standDetailsNotifier.value.countryCode;
  String get defCountryCallingCode =>
      standDetailsNotifier.value.countryCallingCode;

  String get defprintableCurrencySymbol =>
      standDetailsNotifier.value.printableCurrencySymbol;
  int get defmobileMinLength => standDetailsNotifier.value.mobileMinLength;
  int get defmobileMaxLength => standDetailsNotifier.value.mobileMaxLength;
  CountryCodes get defCountryCodeInfo =>
      CountryPickerHandler.getCountryInfoByCallingcode(defCountryCode);

  // bool get haveNewNotification => appNotifications.value.count((x) => x.viewOn != null) > 0;

  Map<String, dynamic> get userDetailsMap => {
    "LoggedStandId": userNotifier.value.siteId,
    "LoggedUserId": userNotifier.value.userId,
    "LoggedRole": userNotifier.value.role.lable,
  };

  // String get generateUniqueID => UniqueCode.getCode(userId);

  int get isMasteruser =>
      loggedUserInfo.loginPasswordMD5 == "66e39b8b71b4ae0cc48a024cbfe9aace"
      ? 1
      : 0;

  CountryCodes getCountryCodeByCallingCodeOrDefault(String callingcode) =>
      CountryPickerHandler.getCountryInfoByCallingcodeOrNull(callingcode) ??
      defCountryCodeInfo;

  // Normal Methods

  Future<bool> makePreLogin() async {
    if (!loggedUserInfo.loginStatus || loggedUserInfo.lastLoginOn == null) {
      return false;
    }

    final t0 = loggedUserInfo.lastLoginOn!.addDay(30).millisecondsSinceEpoch;
    final t1 = DateTime.now().millisecondsSinceEpoch;
    if (t0 < t1) {
      "--".boxLoggedUserInfo;
      return false;
    }

    Map<String, dynamic> lastSyncs = {"loginKey": loggedUserInfo.lastLoginKey};

    await InternetConnectivity.forceSetStatus();

    final resp = await makeUserLogin(
      loginId: loggedUserInfo.loginId,
      loginpw: loggedUserInfo.loginPasswordMD5,
      lastSyncs: lastSyncs,
      timeout: 50,
    );

    await getRemainNessaroryData();

    return resp.resultStatus;
  }

  Future<ApiResponse> makeUserLogin({
    String? loginId,
    String? loginpw,
    Map<String, dynamic>? lastSyncs,
    int timeout = 240,
    bool logoutPrevious = false,
  }) async {
    final device = DevicePackageDetails.instance.details.value;

    if (loginId == null && device.deviceUID.isEmpty) {
      return ApiResponse();
    }

    if (BaseApiHandler.apiConfig.isExpired) {
      return ApiResponse(resultMsj: "App expired !");
    }

    Map<String, dynamic> body = {
      "loginId": loginId,
      "loginPassword": loginpw,
      "fbDeviceToken": "".boxdeviceToken,
      "DeviceType": device.deviceType.onNullOrEmpty(App.platformType),
      "DeviceUID": device.deviceUID,
      "deviceTitle": device.deviceTitle,
      "logoutPrevious": logoutPrevious.value,
      ...?lastSyncs,
    };

    late ApiResponse resp;
    for (var url in [NodeApis.userloginV3]) {
      resp = await baseApiCall(
        url: url,
        apibody: body,
        showloading: false,
        timeout: timeout,
      );

      if ([200, 201].contains(resp.statusCode)) {
        break;
      }
    }

    if (resp.resultStatus) {
      final userInfo = UserDetails.fetch(
        resp.resultData['userInfo'],
        fromServer: true,
      );
      if (userInfo.userId == 0) {
        return ApiResponse(resultMsj: "Unable to login !");
      }

      // user.value = userInfo;

      // final logoutOther = (resp.resultData['UserDetails'] as Map<String,dynamic>).getInt("LogoutOther");

      await setUserDetailsData(userInfo);

      if (!userInfo.role.iscompany) {
        await setStandDetails(
          SiteDetail.fromJsonOrNull(resp.resultData['siteInfo']),
        );

        await getRemainNessaroryData();
      }

      loggedUserInfo = LoggedUserInfo(
        loginStatus: true,
        loginId: loginId ?? '',
        loginPasswordMD5: loginpw ?? '',
        lastLoginKey: userNotifier.value.lastLoginKey,
        userId: userNotifier.value.userId,
        userStandId: userNotifier.value.siteId,
        lastLoginOn: userNotifier.value.loginOn,
      );
      loggedUserInfo.saveToBoxStorage();

      await saveCurrentUserDetailsData();
    }

    return resp;
  }

  Future<(bool, String)> makeUserLogout([bool showLoading = true]) async {
    final device = DevicePackageDetails.instance.details.value;
    final body = {
      "UserID": loggedUserInfo.userId,
      "DeviceUID": device.deviceUID,
    };

    late ApiResponse resp;

    for (var url in [NodeApis.userlogoutV1]) {
      resp = await baseApiCall(
        url: url,
        apibody: body,
        showloading: showLoading,
      );
      if ([200, 201].contains(resp.statusCode)) {
        break;
      }
    }

    return (resp.resultStatus, resp.resultMsj);
  }

  // Saving Info

  Future<void> saveCurrentUserDetailsData() async {
    // await _localDb.database?.userDetailsDao.insert(userNotifier.value);
  }

  // Fetching/Setting Info

  Future<void> getRemainNessaroryData() async {
    getSetProfileImage();
  }

  Future<bool> setUserDetailsData([UserDetails? info]) async {
    bool activeStatus = true;
    // info ??= await _localDb.database?.userDetailsDao.getUserDetail(
    //   loggedUserInfo.userId,
    // );
    // if (App.isMobileDevice && info != null) {
    //   activeStatus = await _localDb.getWorkStaffActiveStatusByUserId(
    //     loggedUserInfo.userId,
    //   );
    // }

    // user.value = info ?? UserDetails();
    userNotifier.value = info ?? UserDetails();
    return info != null && activeStatus && info.isLoggedIn;
  }

  Future<bool> setStandDetails([SiteDetail? info]) async {
    // info ??= await DataProvider.instance.getStandDetail();

    standDetailsNotifier.value = info ?? SiteDetail.withConfig();

    return info != null;
  }

  // It it void becouse some time it take more time
  // at the time or login
  void getSetProfileImage() async {
    final path = userNotifier.value.profileImagePath;
    // await ProfileimageHandler.downloadProfileImageByPath(path);
    profileImage.value = path;
  }

  Future<(bool, String)> onUserLogOut() async {
    bool status = true;
    String message = "Log out sucessfully.";

    makeUserLogout(false);
    await Future.delayed(const Duration(milliseconds: 300));
    clearCurrentUserInfo();

    return (status, message);
  }

  void clearCurrentUserInfo() {
    loggedUserInfo.logoutUser();
    // user.value = UserDetails();
    userNotifier.value = UserDetails();

    standDetailsNotifier.value = SiteDetail.withConfig();
  }
}

/*
{"UserId":"VPA230","Password":"66e39b8b71b4ae0cc48a024cbfe9aace","StandDetailLastSync":null,"VehicalCategoryMasterLastSync":"2024-09-19 17:21:55","VehiclesWhatsAppNoMasterLastSync":"2024-09-27 08:32:22","ParkedVehicalMasterLastSync":"2024-11-09 09:29:34","ParkedVechialPaymentMasterLastSync":"2024-11-09 09:29:34","mWorkingStaffMasterLastSync":"2024-11-07 15:50:49","mParkingPassesMasterLastSync":"2024-09-20 19:13:41","ParkingPassHistoryMasterLastSync":"2024-11-08 16:20:30","mParkingNotesMasterLastSync":"2024-10-12 23:00:37","mStandPlanHistoryMasterLastSync":"2024-09-28 22:24:09","BuildId":"29"}

 */
