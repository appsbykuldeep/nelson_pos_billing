import 'package:pos_billing/common/singletons/base_api_handler.dart';

class SoketEvents {
  // Live server
  // static String sokethost =
  //     '$_scheme://${NodeApis.serverIP}:${NodeApis.host + 1}';
  static String sokethost = BaseApiHandler.apiConfig.nodeSocketPath;

  // // Live server
  // static const String sokethost = 'https://82.112.238.169:1101';

  //   // UAT server
  //   static const String sokethost = 'https://82.112.238.169:2101';

  // Internet IP
  // static const String sokethost = 'http://192.168.29.96:1101';
  // static const String sokethost = 'http://192.168.29.223:1101';
  // static const String sokethost = 'http://172.20.10.11:1101';

  // // Local IP
  // static const String sokethost = 'http://127.0.0.1:1101';

  // envents
  static const String rerouteHandler = 'RerouteHandler';
  static const String getCounterTokenByUser = 'GetCounterTokenByUser';
  static const String updateLastCounterToken = 'UpdateLastCounterToken';
  static const String getLastCounterToken = 'GetLastCounterToken';
  static const String logoutUser = 'LogoutUser';
  static const String changePassword = 'ChangePassword';
  static const String resetUserPassword = 'ResetUserPassword';
  static const String getSiteWiseTokenHistory = 'GetSiteWiseTokenHistory';
  static const String getUserWiseTokenHistory = 'GetUserWiseTokenHistory';
  static const String syncLocalDBV5 = 'SyncLocalDBV5';
  static const String getAllMasterDataV2 = 'GetAllMasterDataV2';
  static const String getItemMasters = 'GetItemMasters';
  static const String saveReceipts = 'SaveReceipts';
  static const String saveAllReceipts = 'SaveAllReceipts';
  static const String getDailyUserWiseSaleReport = 'GetDailyUserWiseSaleReport';
  static const String getSaleHistoryWithItems = 'GetSaleHistoryWithItems';
  static const String getDailyItemWiseSaleReport = 'GetDailyItemWiseSaleReport';
  static const String updateOnlineStandUsers = 'UpdateOnlineStandUsers';
  static const String addEditWorkStaff = 'AddEditWorkStaff';
  static const String emitEventToSiteUsers = 'EmitEventToSiteUsers';
  static const String deleteStandWorkStaff = 'DeleteStandWorkStaff';
}
