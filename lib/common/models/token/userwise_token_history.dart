import 'package:pos_billing/config/enums/token_type.dart';
import 'package:pos_billing/core/extensions/parse_value_by_map.dart';

class UserwiseTokenHistory {
  final DateTime date;
  final TokenType tokenType;
  final int totalTokens;

  UserwiseTokenHistory({
    required this.date,
    required this.tokenType,
    required this.totalTokens,
  });

  static List<UserwiseTokenHistory> fetchList(dynamic data) {
    if (data is List) {
      return List<UserwiseTokenHistory>.from(
        data.map((e) => UserwiseTokenHistory.fromJson(e)),
      );
    }

    return [];
  }

  factory UserwiseTokenHistory.fromJson(
    Map<String, dynamic> json, {
    bool fromServer = true,
  }) {
    return UserwiseTokenHistory(
      date: json.getDateTimeOrNullAccordingSource(
        "date",
        fromServer: fromServer,
      )!,
      tokenType: TokenType.parse(json.getint("tokenType")),
      totalTokens: json.getint("totalTokens"),
    );
  }
}
