import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pos_billing/common/classes/parse_map_value.dart';
import 'package:pos_billing/common/models/basic/country_codes_model.dart';
import 'package:pos_billing/config/constants/assets.dart';
import 'package:pos_billing/core/extensions/list_ext.dart';
import 'package:pos_billing/core/extensions/localdb_ext.dart';
import 'package:pos_billing/core/functions/api_call_function.dart';

class CountryPickerHandler {
  CountryPickerHandler._();

  static final CountryPickerHandler _instance = CountryPickerHandler._();

  static CountryPickerHandler get instance => _instance;

  List<CountryCodes> allCountries = <CountryCodes>[];
  CountryCodes? get india =>
      allCountries.firstWhereOrNull((e) => e.e164CCode == "91");

  static CountryCodes get crrentCountry =>
      getCountryInfoByCallingcode(currentCountryCallCode);

  static CountryCodes? getCountryInfoByCallingcodeOrNull(String callingCode) =>
      _instance.allCountries.firstWhereOrNull(
        (e) => e.e164CCode == callingCode,
      );

  static CountryCodes getCountryInfoByCallingcode(String callingCode) =>
      _instance.allCountries.firstWhereOrNull(
        (e) => e.e164CCode == callingCode,
      ) ??
      CountryCodes.indiaInfo;

  bool isLoaded = false;

  static String currentCountryCallCode = "91";

  Future<void> loadAllCountries() async {
    if (isLoaded) return;
    isLoaded = true;
    try {
      await _setCurrentCountryInfo();

      final data = jsonDecode(
        await rootBundle.loadString(Assets.docsCountryCodes),
      );
      allCountries = CountryCodes.fetchList(
        data,
      ).where((e) => !["92"].contains(e.e164CCode)).toList();
    } catch (e) {
      allCountries = [];
    }
  }

  Future<void> _setCurrentCountryInfo() async {
    bool isIndia = DateTime.now().timeZoneOffset.inMinutes == 330;
    if (isIndia) return;
    final localDb = "".boxCurrentCountryCallCode;
    if (localDb.isNotEmpty) {
      currentCountryCallCode = localDb;
      return;
    }

    final resp = await baseApiCall(
      url: "https://ipapi.co/json/",
      bygetmethod: true,
      timeout: 5,
    );
    if (resp.statusCode == 200 && resp.apiBody is Map<String, dynamic>) {
      final parser = ParseMapValue(input: resp.apiBody);
      final callCode = parser
          .getString("country_calling_code")
          .replaceAll("+", "");
      if (callCode.isNotEmpty) {
        callCode.boxCurrentCountryCallCode;
        currentCountryCallCode = callCode;
      }

      _saveCountryInfoToserver(parser);
    }
  }

  static String? _parseFirstOrString(dynamic data) {
    if (data is String) {
      return data;
    }
    if (data is List && data.isNotEmpty) {
      return data.first.toString();
    }
    if (data is Set && data.isNotEmpty) {
      return data.first.toString();
    }
    return null;
  }

  Future<void> _saveCountryInfoToserver(ParseMapValue parser) async {
    final body = {
      "CountryCode": _parseFirstOrString(parser.getdynamic("country_code")),
      "CountryCodeIOS3": _parseFirstOrString(
        parser.getdynamic("country_code_iso3"),
      ),
      "CountryName": _parseFirstOrString(parser.getdynamic("country_name")),
      "ContinentCode": _parseFirstOrString(parser.getdynamic("continent_code")),
      "UTCOffset": _parseFirstOrString(parser.getdynamic("utc_offset")),
      "CountryCallingCode": _parseFirstOrString(
        parser.getdynamic("country_calling_code"),
      ),
      "Currency": _parseFirstOrString(parser.getdynamic("currency")),
      "CurrencyName": _parseFirstOrString(parser.getdynamic("currency_name")),
    };

    // await baseApiCall(url: ApiList.saveCountryBaseInfo, apibody: body);
  }
}
