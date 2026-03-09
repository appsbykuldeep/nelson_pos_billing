import 'package:pos_billing/config/enums/token_type.dart';
import 'package:pos_billing/core/extensions/parse_value_by_map.dart';

class SitewiseTokenHistory {
  final DateTime date;
  final TokenType tokenType;
  final int totalUsers;
  final int totalTokens;

  SitewiseTokenHistory({
    required this.date,
    required this.tokenType,
    required this.totalUsers,
    required this.totalTokens,
  });

  static List<SitewiseTokenHistory> fetchList(dynamic data) {
    if (data is List) {
      return List<SitewiseTokenHistory>.from(
        data.map((e) => SitewiseTokenHistory.fromJson(e)),
      );
    }

    return [];
  }

  factory SitewiseTokenHistory.fromJson(
    Map<String, dynamic> json, {
    bool fromServer = true,
  }) {
    return SitewiseTokenHistory(
      date: json.getDateTimeOrNullAccordingSource(
        "date",
        fromServer: fromServer,
      )!,
      tokenType: TokenType.parse(json.getint("tokenType")),
      totalUsers: json.getint("totalUsers"),
      totalTokens: json.getint("totalTokens"),
    );
  }
}
