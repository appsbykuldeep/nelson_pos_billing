import 'package:pos_billing/common/models/basic/api_config.dart';

class BaseApiHandler {
  BaseApiHandler._();

  static final BaseApiHandler _instance = BaseApiHandler._();

  static BaseApiHandler get instance => _instance;

  static ApiConfig apiConfig = ApiConfig.forCounterTokenLive();
  // static ApiConfig apiConfig = ApiConfig.forCounterTokenLocal();
}
