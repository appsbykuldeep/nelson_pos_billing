import 'package:pos_billing/common/singletons/base_api_handler.dart';

class NodeApis {
  // Live server
  static const String serverIP = '82.112.238.169';

  // // Internet IP
  // static const String serverIP = '192.168.29.114';
  // static const String serverIP = '192.168.29.68';

  // // Local IP
  // static const String serverIP = '27.0.0.1';

  static const int host = 1100;

  static bool get isLiveIP =>
      ["82.112.238.169", "parkingticket.in"].contains(apihost);

  static int buildNumberForWeb = 82;

  static String get apihost => BaseApiHandler.apiConfig.nodeAPIPath;

  static String joinHost(String path) {
    if (path.isEmpty) {
      return "";
    }
    if (path.startsWith("/")) {
      return "$apihost$path";
    }

    return "$apihost/$path";
  }

  static String userloginV3 = "$apihost/api/userloginv1";
  static String userlogoutV1 = "$apihost/api/userlogoutv1";
  static String reRoute = "$apihost/api/reroute_handler";
  static String getExternalDisplayInfoByUID =
      "$apihost/api/parking/getExternalDisplayInfoByUID";

  static String verifyApi(String apihost) => "$apihost/api/verify";

  // Get online user on server.
  /// http://82.112.238.169:1100/api/test/getOnlineUsers
}
