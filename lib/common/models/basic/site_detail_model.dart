import 'dart:convert';

import 'package:pos_billing/common/classes/parse_map_value.dart';
import 'package:pos_billing/config/enums/token_type.dart';
import 'package:pos_billing/core/extensions/parse_value_by_map.dart';
import 'package:pos_billing/core/extensions/string_ext.dart';

class SiteDetail {
  final int siteId;
  final String siteName;
  final String siteAddressLine1;
  final String siteAddressLine2;
  final String siteMobile;
  final String ownerName;
  final String ownerMobile;

  final String countryCode;
  final String countryCallingCode;
  final int mobileMinLength;
  final int mobileMaxLength;
  final String currencySymbol;
  final String printableCurrencySymbol;

  final double latitude;
  final double longitude;
  final TokenType tokenType;

  final SiteConfigurations siteConfigurations;
  SiteDetail({
    this.siteId = 0,
    this.siteName = '',
    this.siteAddressLine1 = '',
    this.siteAddressLine2 = '',
    this.siteMobile = '',
    this.ownerName = '',
    this.ownerMobile = '',
    this.countryCode = 'IN',
    this.countryCallingCode = '91',
    this.mobileMinLength = 6,
    this.mobileMaxLength = 15,
    this.currencySymbol = '',
    this.printableCurrencySymbol = '',
    this.latitude = 0,
    this.longitude = 0,
    required this.siteConfigurations,
    this.tokenType = TokenType.dateWise,
  });

  (int tokenType, String tokenDate) getTokenTypeAndDate() {
    return (
      tokenType.id,
      tokenType.getTokenDate(dateConfig: siteConfigurations.tokenDateConfig),
    );
  }

  static SiteDetail withConfig() {
    return SiteDetail(siteConfigurations: SiteConfigurations.baseConfig());
  }

  static SiteDetail? fromJsonOrNull(dynamic data) {
    if (data is Map<String, dynamic>) {
      return SiteDetail.fromJson(data);
    }

    return null;
  }

  // static SiteDetail damiSite() {
  //   return SiteDetail(siteName: 'Bawaa Medicals');
  // }

  factory SiteDetail.fromJson(Map<String, dynamic> json) {
    final parser = ParseMapValue(input: json);

    return SiteDetail(
      siteId: parser.getint("siteId"),
      siteName: parser.getString("siteName"),
      siteAddressLine1: parser.getString("siteAddressLine1"),
      siteAddressLine2: parser.getString("siteAddressLine2"),
      siteMobile: parser.getString("siteMobile"),
      ownerName: parser.getString("ownerName"),
      ownerMobile: parser.getString("ownerMobile"),
      countryCode: parser.getString("countryCode"),
      countryCallingCode: parser.getString("countryCallingCode"),
      mobileMinLength: parser.getint("mobileMinLength"),
      mobileMaxLength: parser.getint("mobileMaxLength"),
      currencySymbol: parser.getString("currencySymbol").parseUnicodeChar(),
      printableCurrencySymbol: parser.getString("printableCurrencySymbol"),
      tokenType: TokenType.parse(parser.getint("tokenTypeId")),
      siteConfigurations: SiteConfigurations.parseConfig(
        parser.getdynamic("siteConfigurations"),
      ),
    );
  }
}

class SiteConfigurations {
  final bool isActive;
  final int numberOfprints;
  final int printDelayInSec;
  final TokenDateConfig tokenDateConfig;
  SiteConfigurations({
    required this.isActive,
    required this.numberOfprints,
    required this.printDelayInSec,
    required this.tokenDateConfig,
  });

  static SiteConfigurations baseConfig() =>
      SiteConfigurations.fromJson({}, isActive: true);

  static Map<String, dynamic> _tryDecode(String source) {
    try {
      return jsonDecode(source);
    } catch (e) {
      return {};
    }
  }

  static SiteConfigurations parseConfig(dynamic data) {
    if (data is String && data.isNotEmpty) {
      return SiteConfigurations.fromJson(_tryDecode(data));
    }
    if (data is Map<String, dynamic>) {
      return SiteConfigurations.fromJson(data);
    }

    return baseConfig();
  }

  factory SiteConfigurations.fromJson(
    Map<String, dynamic> json, {
    bool? isActive,
  }) {
    late ParseMapValue parser;

    final makeActive = isActive ?? json.getbool("isActive", true);

    if (makeActive) {
      parser = ParseMapValue(input: json);
    } else {
      parser = ParseMapValue(input: {});
    }

    return SiteConfigurations(
      isActive: isActive ?? parser.getbool("isActive", true),
      numberOfprints: parser.getint("numberOfprints", 1),
      printDelayInSec: parser.getint("printDelayInSec", 3),
      tokenDateConfig: TokenDateConfig.fromJson(
        json.getMap<String, dynamic>("tokenDateConfig"),
      ),
    );
  }
}

class TokenDateConfig {
  final int monthStartDay;
  final int quarterStartDay;
  final int quarterStartMonth;
  final int yearStartDay;
  final int yearStartMonth;
  final int fyStartDay;
  final int fyStartMonth;

  TokenDateConfig({
    required this.monthStartDay,
    required this.quarterStartDay,
    required this.quarterStartMonth,
    required this.yearStartDay,
    required this.yearStartMonth,
    required this.fyStartDay,
    required this.fyStartMonth,
  });

  factory TokenDateConfig.fromJson(Map<String, dynamic> json) {
    final parser = ParseMapValue(input: json);

    return TokenDateConfig(
      monthStartDay: parser.getint("monthStartDay", 1),
      quarterStartDay: parser.getint("quarterStartDay", 1),
      quarterStartMonth: parser.getint("quarterStartMonth", 1),
      yearStartDay: parser.getint("yearStartDay", 1),
      yearStartMonth: parser.getint("yearStartMonth", 1),
      fyStartDay: parser.getint("fyStartDay", 1),
      fyStartMonth: parser.getint("fyStartMonth", 4),
    );
  }
}
