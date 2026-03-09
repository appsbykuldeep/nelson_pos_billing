import 'package:flutter/foundation.dart';
import 'package:pos_billing/common/singletons/base_api_handler.dart';

class ApiList {
  static String get baseapi => BaseApiHandler.apiConfig.phpBaseApiPath;

  static String? getReroutPath(String url) {
    if (kIsWeb && url.startsWith(baseapi)) {
      String reroute = url.replaceFirst(baseapi, "");
      if (reroute.startsWith("/")) {
        return reroute.substring(1);
      }
      return reroute;
    }

    return null;
  }
}
