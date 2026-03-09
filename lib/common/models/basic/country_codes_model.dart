import 'package:pos_billing/core/functions/countrycode_to_emoji.dart';

class CountryCodes {
  /// country calling code
  final String e164CCode;

  /// country code
  final String iso2CCode;
  final String name;
  final String currencySymbol;
  final String timezone;
  final String flag;
  final int mobMinLen;
  final int mobmaxLen;
  CountryCodes({
    required this.e164CCode,
    required this.iso2CCode,
    required this.name,
    required this.currencySymbol,
    required this.flag,
    required this.timezone,
    required this.mobMinLen,
    required this.mobmaxLen,
  });

  //fetchList
  static List<CountryCodes> fetchList(dynamic data) {
    if (data == null) return [];
    try {
      return List<CountryCodes>.from(
        (data as List<dynamic>).map((e) => CountryCodes.fromMap(e)),
      ).toList();
    } catch (e) {
      return [];
    }
  }

  static CountryCodes get indiaInfo => CountryCodes(
    e164CCode: "91",
    iso2CCode: "IN",
    name: "India",
    timezone: "+05:30",
    currencySymbol: "",
    flag: countryCodeToEmoji("IN"),
    mobMinLen: 10,
    mobmaxLen: 10,
  );

  factory CountryCodes.fromMap(Map<String, dynamic> map) {
    int mobMinLen = map['mobMinLen']?.toInt() ?? 0;
    return CountryCodes(
      e164CCode: map['e164_cc'] ?? '',
      iso2CCode: map['iso2_cc'] ?? '',
      name: map['name'] ?? '',
      timezone: map['timezone'] ?? '',
      currencySymbol: map['currencySymbol'] ?? '',
      flag: countryCodeToEmoji(map['iso2_cc'] ?? ''),
      mobMinLen: mobMinLen < 5 ? 5 : mobMinLen,
      mobmaxLen: mobMinLen < 5 ? 12 : mobMinLen,
    );
  }

  @override
  String toString() {
    return 'CountryCodes(e164_cc: $e164CCode, iso2_cc: $iso2CCode, name: $name, mobMinLen: $mobMinLen)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CountryCodes &&
        other.e164CCode == e164CCode &&
        other.iso2CCode == iso2CCode &&
        other.name == name &&
        other.mobMinLen == mobMinLen;
  }

  @override
  int get hashCode {
    return e164CCode.hashCode ^
        iso2CCode.hashCode ^
        name.hashCode ^
        mobMinLen.hashCode;
  }
}
